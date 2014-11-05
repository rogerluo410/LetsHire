class OpeningsController < ApplicationController

#access this  page(index)  should login before  by garfield 
 before_filter :require_login
 
 # before_filter :require_login, :except => [:index, :show]
 # load_and_authorize_resource :except => [:index, :show]

  include ApplicationHelper

  # GET /openings
  def index
#test mail here by garfield and  it works well .  
    #UserMailer.welcome_email(current_user).deliver
     
     @opening = Opening.new(:title => '', :description => description_template)
     @opening.recruiter = current_user if current_user.has_role?(:recruiter)

    # @opening_candidate_filled = OpeningCandidate.where("status ='0'")
    # @opening_candidate_pipeline = OpeningCandidate.where("status ='1'")
    # @opening_candidate_rejected = OpeningCandidate.where("status ='2'")

    unless user_signed_in?
      # Only published openings are returned.
      @openings = Opening.published.order(sort_column('Opening') + ' ' + sort_direction).paginate(:page => params[:page])
      # Here is an exception, we allow anonymous users to see the opening positions, the scenario
      # is that, for these candidates who are interested in these jobs, they can see the job description
      # on the web page.
      render 'openings/index_anonymous'
    else
      # Implement the openings ui page filter query.
      #@default_filter = 'My Openings'
      #case params[:mode]
      #when 'all'
      #  @default_filter = 'All'
      #  @openings = Opening.order(sort_column('Opening') + ' ' + sort_direction).paginate(:page => params[:page])
      #when 'no_candidates'
      #  @default_filter = 'Openings with Zero Candidates'
      #  @openings = Opening.published.without_candidates.owned_by(current_user.id).order(sort_column('Opening') + ' ' + sort_direction).paginate(:page => params[:page])
      #when 'owned_by_me'
      #  @default_filter = 'My Openings'
      #  @openings = Opening.owned_by(current_user.id).order(sort_column('Opening') + ' ' + sort_direction).paginate(:page => params[:page])
      #else
      #  if can? :manage, Opening
      #    @openings = Opening.owned_by(current_user.id).order(sort_column('Opening') + ' ' + sort_direction).paginate(:page => params[:page])
      #  else
          #NOTE: here we get all openings which 'current_user' has interviews on
          #@openings = Opening.paginate(:page => params[:page])
          #everyone  can access all openings 
          #@openings = Opening.interviewed_by(current_user.id).paginate(:page => params[:page])
      #end
      #end
      # show all openings 
      @openings = Opening.order(sort_column('Opening') + ' ' + sort_direction).paginate(:page => params[:page]) 
      render 'openings/index'
    end

  end

  # GET /openings/1
  # GET /openings/1.json
  def show
    @opening = Opening.find(params[:id])

    respond_to do |format|
      format.html # _assessment.html.slim
      format.json { render json: @opening }
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to openings_url, :alert => 'Invalid opening'
  end

  # GET /openings/new
  # GET /openings/new.json
  def new
    @opening = Opening.new(:title => '', :description => description_template)
    @opening.recruiter = current_user if current_user.has_role?(:recruiter)
    # if current_user.has_role?(:hiring_manager)
    #   @opening.hiring_manager_id = current_user.id
    #   @opening.department_id = current_user.department_id
    # end

    respond_to do |format|
      format.html # edit.html.slim
      format.json { render json: @opening }
    end
  end

  # GET /openings/1/edit
  def edit
    @opening = Opening.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to openings_url, :alert => 'Invalid opening'
  end

  # POST /openings
  def create

    @opening = Opening.new(params[:opening])
    tempio = nil
    unless params[:opening][:description].blank?
      tempio = params[:opening][:description]
      params[:opening].delete(:description)
      @opening.name = tempio.original_filename.force_encoding("UTF-8")
    end

    # unless current_user.has_role?(:recruiter)
    #   return redirect_to openings_url, :alert => 'Cannot create Job opening for other hiring managers.' if @opening.hiring_manager_id != current_user.id
    # end
    @opening.creator = current_user
    unless @opening.name.blank?
       filename = Time.now.to_i.to_s+tempio.original_filename.force_encoding("UTF-8")
       @opening.description = filename 
       @opening.path = 'public/uploads/'+ filename  
       @opening.upload(@opening.path, tempio)
    end


    p "DEBUGING...", @opening
    if @opening.save
       #redirect_to @opening, notice: 'Opening was successfully created.'
       redirect_to  "/openings" 
    else
      render action: 'new'
    end
  end

def download_file(filepath,filename)
     mimetype = MIME::Types.type_for(filepath)
     #filename = File.basename(filepath)
     File.open(filepath) do |fp|
       send_data(fp.read, :filename => filename, :type => "#{mimetype[0]}", :disposition => "inline")
     end
     #File.delete(filepath)
end


def openingfile
     @opening = Opening.find params[:id]
 
     unless @opening.nil?
       path = @opening.path
       filename = @opening.name
       download_file(path,filename)
     end
end




  # PUT /openings/1
  def update
    @opening = Opening.find(params[:id])

    authorize! :manage, @opening
    unless current_user.has_role?(:recruiter)
      params[:opening].delete :recruiter_id
      params[:opening].delete :hiring_manager_id
      params[:opening].delete :department_id
    end
    params[:opening].delete :creator_id

    tempio = nil
    unless params[:opening][:description].blank?
      tempio = params[:opening][:description]
      params[:opening].delete(:description)
    end

    # unless current_user.has_role?(:recruiter)
    #   return redirect_to openings_url, :alert => 'Cannot create Job opening for other hiring managers.' if @opening.hiring_manager_id != current_user.id
    # end
    @opening.creator = current_user
    unless tempio.nil?
       filename = Time.now.to_i.to_s+tempio.original_filename.force_encoding("UTF-8")
       @opening.description = filename 
       @opening.name = tempio.original_filename.force_encoding("UTF-8")
       @opening.path = 'public/uploads/'+ filename  
       @opening.upload(@opening.path, tempio)
    end

    OpeningCandidate.transaction do
      if @opening.close_operation?(params[:opening][:status])
        OpeningCandidate.close_opening_preprocess @opening
      end

      if @opening.update_attributes(params[:opening])
        redirect_to @opening, notice: 'Opening was successfully updated.'
      else
        render action: 'edit'
      end
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to openings_url, :alert => 'Invalid opening'
  end

  # POST /openings/1/assign_candidates
  def assign_candidates
    @opening = Opening.find(params[:id])
    authorize! :manage, @opening

    params[:candidates] ||= []
    params[:candidates].each do |candidate|
      opening_candidate = @opening.opening_candidates.where(:candidate_id => candidate).first_or_create
      opening_candidate.update_candidate if opening_candidate
    end
    render :json => { :success => true }
  rescue ActiveRecord::RecordNotFound
    redirect_to request.referrer, :alert => 'Invalid opening'
  end

  # DELETE /openings/1
  # DELETE /openings/1.json
  def destroy
    @opening = Opening.find(params[:id])
    authorize! :manage, @opening
    OpeningCandidate.transaction do
      OpeningCandidate.close_opening_preprocess @opening

      if @opening.published? or @opening.closed?
        if current_user.admin?
          @opening.destroy
        else
          #NOTE: only admin user is able to delete published or closed job openings
          raise CanCan::AccessDenied
        end
      else
        @opening.destroy
      end
    end

    redirect_to openings_url
  rescue ActiveRecord::RecordNotFound
    redirect_to openings_url, :alert => 'Invalid opening'
  end

  # Choice of job location
  def subregion_options
    render :partial => 'utilities/province_select', :locals => { :container => 'opening' }
  end

  # Used in job assignment
  def opening_options
    render :partial => 'opening_selection_combox', :locals => { :selected_department_id => params[:selected_department_id] }
   end

   #wluo opening detail page
   def opening_detail
     @candidate = Candidate.new
     @opening = Opening.find(params[:id])
     @openingcandidates = OpeningCandidate.find(:all,:conditions => "opening_id = "+@opening.id.to_s+" and status = 0"  )
     @candidates = Candidate.active.in_pipeline_loop(0,@opening.id).order(sort_column('Candidate') + ' ' + sort_direction).paginate(:page => params[:page])
     @comment = Comment.new
      render 'openings/_opening_detail_index'
      rescue ActiveRecord::RecordNotFound
      redirect_to openings_url, :alert => 'Invalid opening'
   end

    def opening_detail_single     
     @opening = Opening.find(params[:openingid])
     @interviewer = Interviewer.find(params[:interviewkey])
     @candidate = Candidate.find(params[:candidateid])
     @openingcandidates = OpeningCandidate.find(:all,:conditions => "opening_id = "+@opening.id.to_s+" and status = 0"  )
     @candidates = Candidate.where("id = ? and status = 0",@candidate.id).paginate(:page => params[:page])
     @comment = Comment.new
     Interviewer.update(@interviewer,:state => 1 )
      if @candidates.blank?
      render 'openings/_opening_detail_index',:alert => 'The status of this candidate is changed to "Rejected" or "Make offer"'
      else
      render 'openings/_opening_detail_index'
      end
      rescue ActiveRecord::RecordNotFound
      redirect_to openings_url, :alert => 'Invalid opening'
   end


    def opening_detail_rejected
     @opening = Opening.find(params[:id])
     @openingcandidates = OpeningCandidate.find(:all,:conditions => "opening_id = "+@opening.id.to_s+" and status = 1"  )
     @candidates = Candidate.active.in_pipeline_loop(1,@opening.id).order(sort_column('Candidate') + ' ' + sort_direction).paginate(:page => params[:page])
      render 'openings/_opening_detail_rejected'
      rescue ActiveRecord::RecordNotFound
      redirect_to openings_url, :alert => 'Invalid opening'
   end

   def opening_detail_offers
     @opening = Opening.find(params[:id])
     @openingcandidates = OpeningCandidate.find(:all,:conditions => "opening_id = "+@opening.id.to_s+" and status = 2"  )
     @candidates = Candidate.active.in_pipeline_loop(2,@opening.id).order(sort_column('Candidate') + ' ' + sort_direction).paginate(:page => params[:page])
      render 'openings/_opening_detail_offers'
      rescue ActiveRecord::RecordNotFound
      redirect_to openings_url, :alert => 'Invalid opening'
   end

 

  # Select interviewers during arrange interview
  def interviewers_select
    opening = Opening.find(params[:id])
    mode = params[:mode]
    users = (mode == 'all') ? User.active.all: opening.participants
    render :partial => 'users/user_select', :locals => { :users => users,
                                                         :multiple=> true  }
  rescue
    render :partial => 'users/user_select', :locals => { :users => [] }
  end

  private

  def description_template
    # FIXME: this string should be loaded from 'setting' page
        <<-END_OF_STRING
About Us

ABC is the world leader in virtualization and cloud infrastructure solutions.
We empower our 400,000 customers by simplifying, automating, and transforming
the way they build, deliver, and consume IT. We are a passionate and innovative
group of people, comprised of thousands of top-notch computer scientists and
software engineers spread across the world.

Job Description
We are seeking ....


Requirements
-	condition 1
-	condition 2

        END_OF_STRING
  end
end
