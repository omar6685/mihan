class MihansController < ApplicationController
  before_action :set_mihan, only: %i[ show edit update destroy ]

  # GET /mihans or /mihans.json
  def index
    @mihans = Mihan.all
  end

  # GET /mihans/1 or /mihans/1.json
  def show

  end

  # GET /mihans/new
  def new
    @mihan = Mihan.new
  end

  # GET /mihans/1/edit
  def edit
  end

  # POST /mihans or /mihans.json
  def create
    @mihan = Mihan.new(mihan_params)

    respond_to do |format|
      if @mihan.save
        format.html { redirect_to mihan_url(@mihan), notice: "Mihan was successfully created." }
        format.json { render :show, status: :created, location: @mihan }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @mihan.errors, status: :unprocessable_entity }
      end
    end
  end
  def generate_report
    xlsx_file = params[:xlsx_file]
    csv_file = params[:csv_file]
  
    if xlsx_file.present? && csv_file.present?
      if xlsx_file.content_type == 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' &&
         csv_file.content_type == 'text/csv'
  
        # Process .xlsx file
        workbook = Roo::Spreadsheet.open(xlsx_file.tempfile.path, headers: true)
        worksheet = workbook.sheet(0)
  
        # Extract the data from Excel file
        excel_data = worksheet.to_a
  
        # Process .csv file
        csv_data = CSV.read(csv_file.tempfile.path, headers: true)
  
        common_people = {}
        excel_only_people = {}
        csv_only_people = {}
        saudis_in_csv = {}
        non_saudis_in_csv = {}
        saudis_in_excel = {}
        non_saudis_in_excel = {}
        saudis_in_common_with_salary_range_3000_to_3999 = {}
        saudis_in_common_with_salary_less_than_3000 = {}
        non_saudis_without_identifier = {}
        # Iterate over each row in the CSV file
        csv_data.each do |csv_row|
          csv_identifier = csv_row['IDENTIFIER']
          # Find matching identifier in Excel file
          matching_excel_row = excel_data.find { |excel_row| excel_row[6] == csv_identifier }
          
          if matching_excel_row
            # Add the common person to the hash
            common_people[csv_identifier] = {
              'CONTRIBUTOR_NAME' => matching_excel_row[1],
              'IDENTIFIER' => csv_row['IDENTIFIER'],
              'BASIC_WAGE' => csv_row['BASIC WAGE'],
              'HOUSING' => csv_row['HOUSING'],
              'COMMISSION' => csv_row['COMMISSION'],
              'OTHER_ALLOWANCE' => csv_row['OTHER ALLOWANCE'],
              'الجنسية' => matching_excel_row[2],
              'رقم المنشأة' => matching_excel_row[3],
              'إسم المنشأة' => matching_excel_row[4],
              'رقم الحدود' => matching_excel_row[5],
              'المهنة' => matching_excel_row[7],
              'تاريخ انتهاء الاقامة' => matching_excel_row[8],
              'تاريخ دخول المملكة' => matching_excel_row[9],
            }
          else
            # Add the person only in CSV to the hash
            csv_only_people[csv_identifier] = {
              'CONTRIBUTOR_NAME' => csv_row[0],
              'IDENTIFIER' => csv_row[1],
              'BASIC_WAGE' => csv_row[2],
              'HOUSING' => csv_row[3],
              'COMMISSION' => csv_row[4],
              'OTHER_ALLOWANCE' => csv_row[5]
            }
          end
        end
        # Iterate over each row in the Excel file to find people only in Excel
        excel_data[1..-1].each do |excel_row|
          excel_identifier = excel_row[6]
          unless common_people.key?(excel_identifier)
            # Add the person only in Excel to the hash
            excel_only_people[excel_identifier] = {
              'CONTRIBUTOR_NAME' => excel_row[1],
              'IDENTIFIER' => excel_row[6],
              'الجنسية' => excel_row[2],
              'رقم المنشأة' => excel_row[3],
              'إسم المنشأة' => excel_row[4],
              'رقم الحدود' => excel_row[5],
              'المهنة' => excel_row[7],
              'تاريخ انتهاء الاقامة' => excel_row[8],
              'تاريخ دخول المملكة' => excel_row[9]
            }
          end
        end

        csv_only_people.each do |identifier, person_data|
          if identifier && identifier.start_with?('1')
            saudis_in_csv[identifier] = person_data
          else
            non_saudis_in_csv[identifier] = person_data
          end
        end
  
        excel_only_people.each do |identifier, person_data|
          if identifier && identifier.start_with?('1')
            saudis_in_excel[identifier] = person_data
          else
            non_saudis_in_excel[identifier] = person_data
          end
        end
        
        common_people.each do |identifier, person_data|
          if identifier && identifier.start_with?('1') # Check if the person is Saudi
            basic_wage = person_data['BASIC_WAGE'].to_i
            housing = person_data['HOUSING'].to_i
            salary = basic_wage + housing
        
            if (3000..3999).include?(salary) # Check if the salary falls within the specified range
              saudis_in_common_with_salary_range_3000_to_3999[identifier] = person_data
            end
          end
        end
        
        common_people.each do |identifier, person_data|
          if identifier && identifier.start_with?('1') # Check if the person is Saudi
            basic_wage = person_data['BASIC_WAGE'].to_i
            housing = person_data['HOUSING'].to_i
            salary = basic_wage + housing
        
            if salary < 3000 # Check if the salary is less than 3000
              saudis_in_common_with_salary_less_than_3000[identifier] = person_data
            end
          end
        end
        require 'hijri'

        # Function to convert Hijri date to Gregorian
        def hijri_to_gregorian(hijri_date)
          hijri_parts = hijri_date.split('/')
          year, month, day = hijri_parts.map(&:to_i)
          Hijri::Date.new(year, month, day).to_greo
        end
        
        # Function to calculate remaining days within 90 days for resident permit
        def remaining_days(entry_date_gregorian)
          # Assuming today is the current date
          today = Date.today
          permit_deadline = entry_date_gregorian + 90 # Adding 90 days to the entry date
        
          # Calculate the remaining days
          remaining_days = (permit_deadline - today).to_i
        
          # Ensure the result is non-negative
          remaining_days >= 0 ? remaining_days : 0
        end
        
        excel_data.each do |excel_row|
          identifier = excel_row[6] # Assuming 'IDENTIFIER' is in the 7th column
          if identifier.nil? || identifier.empty? 
            entry_date_hijri = excel_row[9] # Assuming 'تاريخ دخول المملكة' is in the 10th column
            name = excel_row[1] 
            border_number = excel_row[5] 
            entry_date_gregorian = hijri_to_gregorian(entry_date_hijri) # Convert Hijri date to Gregorian
            remaining_days = remaining_days(entry_date_gregorian) # Calculate remaining days
        
            non_saudis_without_identifier[name] = {
              'NAME' => name,
              'BORDER_NUMBER' => border_number,
              'ENTRY_DATE_HIJRI' => entry_date_hijri,
              'ENTRY_DATE' => entry_date_gregorian,
              'REMAINING_DAYS' => remaining_days
            }
          end
        end
        company_name = excel_data[1][4].strip # Assuming "إسم المنشأة" is in the fifth column (index 4)
        # Now you have a hash non_saudis_without_identifier containing non-Saudi contributors in excel_data without an 'IDENTIFIER', along with their entry date in Hijri and remaining days.
        
        # Now, common_people hash contains the information for common contributors in both files
        # excel_only_people hash contains the information for contributors only in Excel
        # csv_only_people hash contains the information for contributors only in CSV
        Mihan.create(
          saudis_only_in_csv: saudis_in_csv,
          saudis_in_excel_not_in_csv: saudis_in_excel,
          saudis_in_both_files_half: saudis_in_common_with_salary_range_3000_to_3999,
          saudis_in_both_files_zero: saudis_in_common_with_salary_less_than_3000,
          foreigners_in_csv_not_in_excel: non_saudis_in_csv,
          foreigners_in_excel_not_in_csv: non_saudis_in_excel,
          foreigners_without_residence: non_saudis_without_identifier,
        )
  
        redirect_to root_path, notice: 'Reports generated successfully!'
      else
        redirect_to root_path, alert: 'Please upload valid .xlsx and .csv files.'
      end
    else
      redirect_to root_path, alert: 'Please upload both .xlsx and .csv files.'
    end
  end
   
  

  # PATCH/PUT /mihans/1 or /mihans/1.json
  def update
    respond_to do |format|
      if @mihan.update(mihan_params)
        format.html { redirect_to mihan_url(@mihan), notice: "Mihan was successfully updated." }
        format.json { render :show, status: :ok, location: @mihan }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @mihan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mihans/1 or /mihans/1.json
  def destroy
    @mihan.destroy

    respond_to do |format|
      format.html { redirect_to mihans_url, notice: "Mihan was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mihan
      @mihan = Mihan.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def mihan_params
      params.require(:mihan).permit(:foreigners_in_excel_not_in_csv, :foreigners_without_residence, :saudis_only_in_csv, :saudis_in_excel_not_in_csv, :saudis_in_both_files_half, :saudis_in_both_files_zero)
    end
end
