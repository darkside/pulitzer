class Pulitzer::ContentElementsController < Pulitzer::ApplicationController
  before_filter :set_content_element, only: [:show, :edit, :update]

  def new
    @version           = Pulitzer::Version.find params[:version_id]
    @content_element   = @version.content_elements.build
    render partial: 'new', locals: { content_element: @content_element, version: @version }
  end

  def create
    @version         = Pulitzer::Version.find content_element_params[:version_id]
    @content_element = @version.content_elements.create content_element_params.merge(ensure_unique: true)
    render partial: 'show_wrapper', locals: { content_element: @content_element }
  end

  def show
    render partial: 'show', locals: { content_element: @content_element }
  end

  def edit
    render partial: 'form', locals: { content_element: @content_element }
  end

  def update
    @content_element.update content_element_params
    render partial: 'show', locals: { content_element: @content_element }
  end

  def update_all
    content_elements = Pulitzer::ContentElement.find params[:content_element]
    content_elements.each do |ce|
      new_sort_order = params[:content_element].index(ce.id.to_s)
      ce.update_attribute(:sort_order, new_sort_order)
    end
    render nothing: true
  end

  protected

  def content_element_params
    params[:content_element].permit!
  end

  def set_content_element
    @content_element = Pulitzer::ContentElement.find(params[:id])
  end
end
