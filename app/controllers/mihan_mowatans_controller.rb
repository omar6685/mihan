class MihanMowatansController < ApplicationController
  before_action :set_mihan_mowatan, only: %i[ show edit update destroy ]

  # GET /mihan_mowatans or /mihan_mowatans.json
  def index
    @mihan_mowatans = MihanMowatan.all
  end

  # GET /mihan_mowatans/1 or /mihan_mowatans/1.json
  def show
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


      company_name = excel_data[1][4].strip 
      
      result = process_excel_data(excel_data)  # You need to implement this method

      Mihan.create(
        result: result,
        company_name: company_name,
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
    
    # Method to process Excel data
    def process_excel_data(data)
    end
end
