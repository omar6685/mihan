class MihanMowatansController < ApplicationController
  before_action :set_mihan_mowatan, only: %i[ show edit update destroy ]

  # GET /mihan_mowatans or /mihan_mowatans.json
  def index
    @mihan_mowatans = MihanMowatan.all
  end

  # GET /mihan_mowatans/1 or /mihan_mowatans/1.json
  def show
    @mihan_mowatan = MihanMowatan.find(params[:id])
    @result = JSON.parse(@mihan_mowatan.result)
  end

  # GET /mihan_mowatans/new
  def new
    @mihan_mowatan = MihanMowatan.new
  end

  # GET /mihan_mowatans/1/edit
  def edit
  end

  # POST /mihan_mowatans or /mihan_mowatans.json
  def create
    @mihan_mowatan = MihanMowatan.new(mihan_mowatan_params)

    respond_to do |format|
      if @mihan_mowatan.save
        format.html { redirect_to mihan_mowatan_url(@mihan_mowatan), notice: "Mihan mowatan was successfully created." }
        format.json { render :show, status: :created, location: @mihan_mowatan }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @mihan_mowatan.errors, status: :unprocessable_entity }
      end
    end
  end

  def generate_report
    xlsx_file = params[:xlsx_file]
  
    if xlsx_file.present? && xlsx_file.content_type == 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' 
      # Process .xlsx file
      workbook = Roo::Spreadsheet.open(xlsx_file.tempfile.path, headers: true)
      worksheet = workbook.sheet(0)

      # Extract the data from Excel file
      excel_data = worksheet.to_a


      
      result = process_employee_list(excel_data)  # You need to implement this method

      MihanMowatan.create(
        result: result.to_json,
      )

      redirect_to root_path, notice: 'Reports generated successfully!'

    else
      redirect_to root_path, alert: 'Please upload valid .xlsx'
    end
  end



  # PATCH/PUT /mihan_mowatans/1 or /mihan_mowatans/1.json
  def update
    respond_to do |format|
      if @mihan_mowatan.update(mihan_mowatan_params)
        format.html { redirect_to mihan_mowatan_url(@mihan_mowatan), notice: "Mihan mowatan was successfully updated." }
        format.json { render :show, status: :ok, location: @mihan_mowatan }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @mihan_mowatan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mihan_mowatans/1 or /mihan_mowatans/1.json
  def destroy
    @mihan_mowatan.destroy

    respond_to do |format|
      format.html { redirect_to mihan_mowatans_url, notice: "Mihan mowatan was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mihan_mowatan
      @mihan_mowatan = MihanMowatan.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def mihan_mowatan_params
      params.require(:mihan_mowatan).permit(:result, :company_name)
    end

    def process_employee_list(excel_data)
      # Load guide data and parse JSON
      guide_data_json = Guide.last.file
      guide_data = JSON.parse(guide_data_json)
    
      # Process guide data and prepare necessary structures
      guide_mapping = {}
      guide_data.each_with_index do |row, index|
        next if index == 0  # Skip the header row
        category = row[1]
        jobs = row[2].split('،').map(&:strip)
        guide_mapping[category] ||= []
        guide_mapping[category] += jobs
      end
    
      # Initialize category counts
      category_counts = Hash.new { |h, k| h[k] = { total: 0, saudi: 0 } }
    
      # Iterate through employee data and calculate metrics
      excel_data.each do |employee|
        job = employee[7]
        nationality = employee[2]
    
        guide_mapping.each do |category, jobs|
          if jobs.include?(job)
            category_counts[category][:total] += 1
            category_counts[category][:saudi] += 1 if nationality == 'سعودي'
          end
        end
      end
    
      # Process results
      results = {}
      category_counts.each do |category, counts|
        guide_row = guide_data.find { |row| row[1] == category }
        next unless guide_row
    
        saudi_percentage = counts[:total] == counts[:saudi] ? 100 : ((counts[:saudi] / counts[:total].to_f) * 100).round(2)
        applicable = counts[:total] >= guide_row[3] && saudi_percentage < guide_row[4] ? 'نعم' : 'لا'
    
        # Filter employees based on guide jobs
        employees = excel_data.select { |employee| guide_mapping[category].include?(employee[7]) }.map { |employee| employee[1] }
    
        # Prepare result
        results[category] = {
          applicable: applicable,
          employees: employees,
          required_percentage: guide_row[4],
          actual_saudi_percentage: saudi_percentage,
          required_saudis: applicable == 'نعم' ? required_saudi(counts[:saudi], counts[:total], guide_row[4]) : 0,
          advice: applicable == 'نعم' ? guide_row[9] : '--',
          assistance_condition: applicable == 'نعم' ? guide_row[10] : '--'
        }
      end
    
      results
    end
    
    
    
    def required_saudi(actual_saudi, total, percentage)
      add = 0
      p = 0
      return 0 if total == 0
    
      loop do
        p = ((actual_saudi + add) / total) * 100
        break if p >= percentage
    
        add += 1
      end
    
      add
    end
end
