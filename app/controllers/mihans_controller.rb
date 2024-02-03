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
