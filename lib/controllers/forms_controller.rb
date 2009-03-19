class FormsController < ApplicationController

  def index
    @forms = Form.paginate(:all, :page => params[:page] || 1)
  end
  
  def show
    @form = Form.find(params[:id])
    @form_submission = @form.form_submissions.build
    render :template => 'form_submissions/new'
  end
  
  def new
    @form = Form.new
    @form.submit_label = 'Submit'
  end
  
  def edit
    @form = Form.find(params[:id])
  end
  
  def create
    preview_new and return if params[:commit].to_s.downcase == 'preview'
    
    @form = Form.new(params[:form])
    if @form.save
      redirect_to form_path(@form)
    else
      render :action => 'new'
    end
  end
  
  def update
    preview_edit and return if params[:commit].to_s.downcase == 'preview'

    @form = Form.find params[:id]
    
    if @form.update_attributes(params[:form])
      redirect_to form_path(@form)
    else
      render :action => 'edit'
    end
  end
  
  private
  
  def preview_new
    @form = Form.new(params[:form])
    if @form.valid?
      @form_submission = @form.form_submissions.build
      @form_submission.form = @form # Believe it or not, this is necessary
    end
    render :action => 'new'
  end
  
  def preview_edit
    # @form = current_company.Form.find(params[:id])
    # @form.attributes = params[:form]
    @form = Form.new(params[:form])
    @form.id = params[:id]
    if @form.valid?
      @form_submission = @form.form_submissions.build
      @form_submission.form = @form # Believe it or not, this is necessary
    end
    render :action => 'edit'
  end
end

