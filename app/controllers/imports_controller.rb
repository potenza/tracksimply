class ImportsController < ApplicationController
  before_action :require_user, :require_admin, :set_site
  before_action :set_formats, only: [:new, :create]

  def index
    @imports = @site.imports.includes(:user).order("created_at DESC")
  end

  def new
    @import = Import.new
  end

  def create
    @import = @site.imports.build(import_params)
    if @import.save
      redirect_to site_import_path(@site, @import)
    else
      render :new
    end
  end

  def show
    @import = @site.imports.find(params[:id])
    if @import.import_format_id.nil?
      redirect_to new_import_format_path(import_id: @import.id)
    end
  end

  def destroy
    import = @site.imports.find(params[:id])
    import.destroy
    redirect_to site_imports_path(@site), notice: "Import deleted"
  end

  private

  def set_formats
    @formats = ImportFormat.all.collect { |format| [ format.file_type, format.id ] }
  end

  def set_site
    @site = Site.find(params[:site_id])
  end

  def import_params
    params.require(:import).permit(:import_format_id, :file).merge(user_id: current_user.id)
  end
end
