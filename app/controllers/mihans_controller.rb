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
        # Initialize a hash to store the mapping of names
        contributor_data = {}
        
        # Iterate through each row in the CSV file (skipping the header)
        csv_data[1..-1].each do |csv_row|
          contributor_name_csv = csv_row[0].strip # Assuming the name is in the first column
          contributor_nationality_csv = csv_row[2].strip # Assuming nationality is in the third column
          basic_wage = csv_row[2].to_i # Assuming BASIC WAGE is in the third column
          housing = csv_row[3].to_i # Assuming HOUSING is in the fourth column
        
          # Search for the contributor in Excel data
          match_excel = excel_data.find { |excel_row| excel_row[1].casecmp(contributor_name_csv.downcase).zero? }
        
          if match_excel
            # Calculate the salary by adding BASIC WAGE and HOUSING
            salary = basic_wage + housing
        
            # Add the names, nationality, and salary to the hash
            contributor_data[contributor_name_csv] = {
              name: match_excel[1].strip,
              nationality: match_excel[2].strip,
              salary: salary
            }
          end
        end
        
        # Now, the contributor_data hash contains the names, nationality, and salary

        # Initialize a hash to store the names of Saudis in CSV but not in Excel
        saudis_only_in_csv = {}
        
        # Iterate through each row in the CSV file (skipping the header)
        csv_data[1..-1].each do |csv_row|
          contributor_name_csv = csv_row[0].strip # Assuming the name is in the first column
          contributor_nationality_csv = csv_row[2].strip # Assuming nationality is in the third column
        
          # Search for the contributor in Excel data
          match_excel = excel_data.find { |excel_row| excel_row[1].casecmp(contributor_name_csv.downcase).zero? }
        
          if contributor_nationality_csv.downcase == 'سعودي'
            if match_excel.nil?
              # Add the Saudi names to the hash if they are not in the Excel file
              saudis_only_in_csv[contributor_name_csv] = {
                nationality: contributor_nationality_csv
              }
            end
          end
        end
        # Initialize a hash to store the names of Saudis in Excel but not in CSV
        saudis_in_excel_not_in_csv = {}
        
        # Helper function to clean and normalize names for comparison
        def clean_and_normalize(name)
          name.to_s.gsub(/[^0-9a-zA-Z]/, '').downcase
        end
        
        # Iterate through each row in the Excel file (skipping the header)
        excel_data[1..-1].each do |excel_row|
          contributor_name_excel = clean_and_normalize(excel_row[1])
          contributor_nationality_excel = excel_row[2].strip # Assuming nationality is in the third column
        
          # Search for the contributor in CSV data
          match_csv = csv_data.find { |csv_row| clean_and_normalize(csv_row[0]) == contributor_name_excel }
        
          if contributor_nationality_excel.downcase == 'سعودي'
            if match_csv.nil?
              # Add the Saudi names to the hash if they are not in the CSV file
              saudis_in_excel_not_in_csv[contributor_name_excel] = {
                nationality: contributor_nationality_excel
              }
            end
          end
        end
        # Initialize a hash to store the names of Saudis with the specified salary range
        saudis_in_both_files_half = {}
        
        # Iterate through each row in the CSV file (skipping the header)
        csv_data[1..-1].each do |csv_row|
          contributor_name_csv = csv_row[0].strip # Assuming the name is in the first column
          contributor_nationality_csv = csv_row[2].strip # Assuming nationality is in the third column
          basic_wage = csv_row[2].to_i # Assuming BASIC WAGE is in the third column
          housing = csv_row[3].to_i # Assuming HOUSING is in the fourth column
        
          # Check if the contributor is Saudi and has a salary between 3000 and 3999
          if contributor_nationality_csv == "سعودي" && (3000..3999).cover?(basic_wage + housing)
            # Add the name to the hash
            saudis_in_both_files_half[contributor_name_csv] = true
          end
        end
        # Initialize a hash to store the names of Saudis with salary less than 3000
        saudis_in_both_files_zero = {}
        
        # Iterate through each row in the CSV file (skipping the header)
        csv_data[1..-1].each do |csv_row|
          contributor_name_csv = csv_row[0].strip # Assuming the name is in the first column
          contributor_nationality_csv = csv_row[2].strip # Assuming nationality is in the third column
          basic_wage = csv_row[2].to_i # Assuming BASIC WAGE is in the third column
          housing = csv_row[3].to_i # Assuming HOUSING is in the fourth column
        
          # Check if the contributor is Saudi and has a salary less than 3000
          if contributor_nationality_csv == "سعودي" && (basic_wage + housing) < 3000
            # Add the name to the hash
            saudis_in_both_files_zero[contributor_name_csv] = true
          end
        end
        # Initialize a hash to store the names of non-Saudis in Excel but not in CSV
        foreigners_in_excel_not_in_csv = {}
        
        # Iterate through each row in the Excel data (skipping the header)
        excel_data[1..-1].each do |excel_row|
          contributor_name_excel = excel_row[1].strip.downcase # Assuming the name is in the second column
        
          # Search for the contributor in CSV data
          match_csv = csv_data.find { |csv_row| csv_row[0].strip.downcase == contributor_name_excel }
        
          # Check if the contributor is not in CSV and is not Saudi
          if !match_csv && excel_row[2].strip != "سعودي"
            # Add the name to the hash
            foreigners_in_excel_not_in_csv[excel_row[1].strip] = true
          end
        end
        # Initialize a hash to store the names of non-Saudis in CSV but not in Excel
        foreigners_in_csv_not_in_excel = {}
        
        # Iterate through each row in the CSV data (skipping the header)
        csv_data[1..-1].each do |csv_row|
          contributor_name_csv = csv_row[0].strip.downcase # Assuming the name is in the first column
        
          # Search for the contributor in Excel data
          match_excel = excel_data.find { |excel_row| excel_row[1].strip.downcase == contributor_name_csv }
        
          # Check if the contributor is not in Excel and is not Saudi
          if !match_excel && csv_row[2].strip.downcase != "سعودي"
            # Add the name to the hash
            foreigners_in_csv_not_in_excel[contributor_name_csv] = true
          end
        end
        
        # Now, non_saudis_in_csv contains the names of non-Saudis in CSV but not in Excel
        # Now, non_saudis_in_excel contains the names of non-Saudis in Excel but not in CSV

        
        # Now, non_saudis_in_excel contains the names of non-Saudis in Excel but not in CSV

        # Now, saudis_with_low_salary contains the names of Saudis with salary less than 3000

        # Now, saudis_with_salary_range contains the names of Saudis with the specified salary range

        # Now, the saudis_not_in_csv hash contains the names of Saudis not in the CSV file

        # Now, the saudis_not_in_excel hash contains the names of Saudis not in the Excel file

        # Now, the contributor_data hash contains the desired mapping
        Mihan.create(
          saudis_only_in_csv: saudis_only_in_csv,
          saudis_in_excel_not_in_csv: saudis_in_excel_not_in_csv,
          saudis_in_both_files_half: saudis_in_both_files_half,
          saudis_in_both_files_zero: saudis_in_both_files_zero,
          foreigners_in_excel_not_in_csv: foreigners_in_excel_not_in_csv,
          foreigners_in_csv_not_in_excel: foreigners_in_csv_not_in_excel
        )
        # Now, contributor_data hash contains the information for contributors existing in both files
  
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
