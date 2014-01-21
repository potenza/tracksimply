require 'csv'

class ImportFormatsController < ApplicationController
  before_action :require_user, :require_admin

  def index
    @import_formats = ImportFormat.all
  end

  def new
    @import_format = ImportFormat.new
    @import = Import.includes(:site).find(params[:import_id])
    @site = @import.site
  end

  def create
    @import_format = ImportFormat.new(import_format_params)
    @import = Import.includes(:site).find(params[:import_id])
    @site = @import.site

    if @import_format.save
      @import.update_attribute(:import_format_id, @import_format.id) # triggers after_commit
      redirect_to [@site, @import]
    else
      render :new
    end
  end

  def destroy
    import_format = ImportFormat.find(params[:id])
    import_format.destroy
    redirect_to import_formats_path, notice: "Import Format deleted"
  end

  private

  def import_format_params
    columns = params[:columns]
      .find_all { |k, v| v.present? } # find non-empty values: [["0", "date_column"], ["6", "url_column"], ["17", "cost_column"]]
      .map { |e| [e[1], e[0]] } # flip array elements
      .flatten # flatten the array: ["date_column", "0", "url_column", "6", "cost_column", "17"]
    Hash[*columns].merge file_type: params[:import_format][:file_type] # turn into hash and merge file_type param
  end
end
