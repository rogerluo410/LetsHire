class CandidatesController < AuthenticatedController
  load_and_authorize_resource :except => [:create, :update, :index_for_selection ]

  # Predefined maximum uploaded file size, 10M
  MAX_FILE_SIZE = 10 * 1024 * 1024

  include ApplicationHelper

  FILTER_LITERAL = {
      :no_openings => 'Active Candidates without job openings',
      :with_opening => 'Active Candidates assigned to job openings',
      :no_interviews => 'Active Candidates without interviews',
      :with_assessment => 'Interviewed Candidates with final assessment',
      :without_assessment => 'Interviewed Candidates with no final assessment',
      :active => 'Active Candidates',
      :inactive => 'Blacklisted Candidates',
      :all => 'All'
  }

 
  def index
    
   @candidate = Candidate.new    
  
   @comment = Comment.new
  
   @openingcandidate = OpeningCandidate.new
 
   @default_filter = 'All Active Candidates'
   mode = (params.has_key? :mode) ? params[:mode].to_s : 'active'
   @default_filter = FILTER_LITERAL[mode.to_sym] || 'Active Candidates'

    # Implement the candidates ui page filter query.
    @candidates = (if %w[no_openings no_interviews with_assessment without_assessment with_opening].include?(mode)
      Candidate.active.send(mode.to_sym)
    elsif mode == 'inactive'
      Candidate.inactive
    elsif mode == 'all'
      Candidate
    else
      opening = nil
      if (params[:opening_id])
       opening = Opening.find(params[:opening_id])
      end
      if opening
       opening.active_candidates
      else
       # NOTE: show active candidates by default
       Candidate.active
      end 
    end).order(sort_column('Candidate') + ' ' + sort_direction).paginate(:page => params[:page] )
 

    @candidates.each do |candidate|
     openingcandidate = OpeningCandidate.where(:candidate_id => candidate.id)
     if !openingcandidate.empty?
     candidate.rating = candidate.setRating(openingcandidate[0].id)
     end
    end

  end


  def show
    # show candidate detailed info, such as name/contact info/current status
    @candidate = Candidate.find params[:id]
    @opening = nil
    @interviews = []
    @assessment = nil
    # show candidate current applying job's interviews status
    if @candidate.current_opening_candidate_id > 0
      @latest_applying_job = OpeningCandidate.find(@candidate.current_opening_candidate_id)
      @opening_candidate = @latest_applying_job
      @opening = @latest_applying_job.opening
      @interviews = @latest_applying_job.interviews
      unless @latest_applying_job.assessment.nil?
        @assessment = @latest_applying_job.assessment
      else
        @assessment = @latest_applying_job.create_assessment(:opening_candidate_id => @latest_applying_job.id)
      end
    end

    # show candidate job applying history
    @applying_jobs = nil
    unless @latest_applying_job.nil?
      @applying_jobs = @candidate.opening_candidates.where("opening_candidates.id != #{@latest_applying_job.id}").order("opening_candidates.id DESC")
    end
    
    @resume = @candidate.resume.name unless @candidate.resume.nil?
  rescue ActiveRecord::RecordNotFound
    return render :text => "", :alert => 'Invalid candidate'
  end

  def new
    @candidate = Candidate.new
  end

  def edit
    @candidate = Candidate.find params[:id]
    @resume = @candidate.resume.name unless @candidate.resume.nil?
  rescue ActiveRecord::RecordNotFound
    redirect_to request.referrer, :alert => 'Invalid candidate'
  end

  # Used in assigning candidate to opening jobs
  def index_for_selection
    if params[:exclude_opening_id]
      exclude_opening = Opening.find(params[:exclude_opening_id])
      @candidates = Candidate.active.not_in_opening(exclude_opening.id).paginate(:page => params[:page])
    else
      @candidates = Candidate.active.paginate(:page => params[:page])
    end
    render :action => :index_for_selection, :layout => false
  end

def setReject
    @openca = OpeningCandidate.where("candidate_id = ? AND opening_id = ?", params[:id], params[:openingid])
    @candidate = Candidate.find(params[:id])
    if @candidate.openingid == -1
      redirect_to "/candidates", :alert =>'This candidate has already been removed.'    
      return
    end
    if @candidate.rating > 0
    redirect_to "/candidates", :alert => "You can not 'Reject' this candidate,because the status of this candidate is locked. If you have permission to unlock,you can unlock by yourself,and then click 'Reject' button to reject. Or you can find someone who has permission to unlock to unlock this candidate's status,and then do what you want to do."
    else
    OpeningCandidate.transaction do  
    if OpeningCandidate.update(@openca,:status => 1) && Candidate.update(@candidate, :status => 1 ,:rating => 1)
      redirect_to "/candidates", :notice => "Candidate \"#{params[:name]}\" was successfully Rejected."
     else
      redirect_to "/candidates", :alert => "Failed to reject Candidate \"#{params[:name]}\"."
    end
    end # transaction
    end # if @candidate[0].rating > 0
    rescue ActiveRecord::RecordNotFound
    redirect_to candidates_url, :alert => 'Invalid Candidate'
end

def setOffer
    @openca = OpeningCandidate.where("candidate_id = ? AND opening_id = ?", params[:id], params[:openingid])
    @candidate = Candidate.find(params[:id])
    @opening = Opening.find(params[:openingid])
    if @candidate.openingid == -1
      redirect_to "/candidates", :alert =>'This candidate has already been removed.'
      return
    end
    if @candidate.rating > 0
    redirect_to "/candidates", :alert => "You can not 'Make offer' for this candidate,because the status of this candidate is locked. If you have permission to unlock,you can unlock by yourself,and then click 'Make offer' button to offer. Or you can find someone who has permission to unlock to unlock this candidate's status,and then do what you want to do." 
    elsif @opening.filled_no >= @opening.total_no
    redirect_to "/candidates", :alert => "You can not 'Make offer' for this candidate,because the total number of opening is up to top."
    else
    OpeningCandidate.transaction do
    if OpeningCandidate.update(@openca,:status => 2) && Candidate.update(@candidate, :status => 2,:source => params[:summary],:rating => 1) && Opening.update(@opening,:filled_no =>@opening.filled_no+1)
      redirect_to "/candidates", :notice => "Candidate \"#{params[:name]}\" was successfully Offered."
    else
      redirect_to "/candidates", :alert => "Failed to make offer for Candidate \"#{params[:name]}\"."
    end
    end #transaction
    end #if @candidate.rating > 0
    rescue ActiveRecord::RecordNotFound
    redirect_to candidates_url, :alert => 'Invalid Candidate'
end

def setRemove
    @openca = OpeningCandidate.where("candidate_id = ? AND opening_id = ?", params[:id], params[:openingid])
    @candidate = Candidate.find(params[:id])
    if @candidate.openingid == -1
      redirect_to "/openings/opening_detail/#{params[:openingid]}", :alert =>'This candidate has already been removed.'
      return
    end
    OpeningCandidate.transaction do
    if OpeningCandidate.update(@openca,:opening_id => -1) && Candidate.update(@candidate, :openingid => -1)
      redirect_to "/openings/opening_detail/#{params[:openingid]}", :notice => "Candidate \"#{params[:name]}\" was successfully Removed."
     else
      redirect_to "/openings/opening_detail/#{params[:openingid]}", :alert => "Failed to remove Candidate \"#{params[:name]}\"."
    end
    end # transaction
    rescue ActiveRecord::RecordNotFound
    redirect_to candidates_url, :alert => 'Invalid Candidate'
end



def setLock
   @candidate = Candidate.find(params[:id])
   if @candidate.openingid == -1
      redirect_to "/candidates", :alert =>'This candidate has already been removed.'
      return
   end
   #validate entitlement
   if @candidate.rating ==0
   Candidate.update(@candidate,:rating => 1 )
   else
   Candidate.update(@candidate,:rating => 0 ) 
   end
   redirect_to "/candidates", :notice => "Candidate \"#{@candidate.name}\" Locked/Unlocked successfully."
   rescue ActiveRecord::RecordNotFound
   redirect_to candidates_url, :alert => 'Invalid Candidate'
end

def setSummary
 @candidate = Candidate.find(params[:id])
 Candidate.update(@candidate,:source => params[:summary])
 render :text => 'success' , status=>"200 ok" 
end

def create_delegated_interviewers
   openingcandidateid = params[:openingcandidateid]
   list = params[:list]
   pageid = params[:pageid]
   openingcandidate = OpeningCandidate.find(openingcandidateid)
   @candidate = Candidate.find(openingcandidate.candidate_id)
   if @candidate.openingid == -1
      redirect_to "/candidates", :alert =>'This candidate has already been removed.'
      return
   end
  # @interviewers = Interviewer.where( "interview_id = ?",openingcandidateid)
  # if !@interviewers.empty?
  #  if pageid.to_i == 1
  #  redirect_to "/candidates",  :alert => "Already selected delegated users."  
  #  else
  #  redirect_to "/openings/opening_detail/#{openingcandidate.opening_id}",     :alert => "Already selected delegated users."
  #  end
  #  return
  # end 
  
   if !list.to_s.blank?
   
   new_string = ""
   new_records = "" 
   list.split(/,/).each do | userid |
     interviewer_temp = Interviewer.where( "interview_id = ? and user_id = ?",openingcandidateid,userid)
     if interviewer_temp.empty?
      new_string += "{\"interview_id\":"+openingcandidateid.to_s+",\"user_id\":"+userid.to_s+"} ,"
      user = User.find(userid)
      #need to send Email after save successfully 
      Mailer.delegate_email(user).deliver 
     end
   end
   new_records =  new_string.chomp(",") 
   new_records = "["+new_records+"]"
   puts new_records
   if Interviewer.create(JSON(new_records))
    if pageid.to_i == 1
      redirect_to "/candidates",  :notice => "Set delegated users successfully."
    else 
      redirect_to "/openings/opening_detail/#{openingcandidate.opening_id}", :notice => "Set delegated users successfully."
    end
   return
   else
     if pageid.to_i == 1
      redirect_to "/candidates",  :notice => "Failed to set delegated users."
    else
      redirect_to "/openings/opening_detail/#{openingcandidate.opening_id}", :notice => "Failed to set delegated users."
    end
   return
   end
   end
end

  def create
    tempio = nil
    unless params[:candidate][:resume].blank?
      tempio = params[:candidate][:resume]
      params[:candidate].delete(:resume)
      filename = Time.now.to_i.to_s+tempio.original_filename.force_encoding("UTF-8") 
    end
   
    params[:candidate].delete(:department_id)
    opening_id = params[:candidate][:opening_id]
    params[:candidate].delete(:opening_id)
    #authorize! :create, Candidate
    #everyone can create candidate 
    @candidate = Candidate.new params[:candidate]
    @candidate.description = filename
    unless filename.blank?
       @candidate.path = 'public/uploads/'+ filename
       @candidate.upload(@candidate.path, tempio)
    end

    if @candidate.save
      if opening_id
        opening_candidate = @candidate.opening_candidates
                                    .where(:opening_id => opening_id, :candidate_id => @candidate.id)
                                    .first_or_create
        opening_candidate.update_candidate if opening_candidate
      end

      puts @candidate.id
      puts @candidate.openingid  
      new_string="{\"candidate_id\":\""+@candidate.id.to_s+"\",\"opening_id\":\""+@candidate.openingid.to_s+"\",\"status\":\"0\"}"
      new_records = "["+new_string+"]"
      OpeningCandidate.create(JSON(new_records)); 

      # TODO: async large file upload
      unless tempio.nil?
        if tempio.size > MAX_FILE_SIZE
          render :status => 400, :json => {:message => 'File size cannot be larger than 10M.'}
          return
       end

        @resume = @candidate.build_resume
        @resume.savefile(tempio.original_filename, tempio)
      end
      if  @candidate.openingname.nil? 
      redirect_to "/candidates" , :notice => "Create candidate \"#{@candidate.name}\"  successfully."
      else
      redirect_to "/openings/opening_detail/#{@candidate.openingid}" ,:notice => "Create candidate \"#{@candidate.name}\"  successfully."
      end
      #redirect_to @candidate, :notice => "Candidate \"#{@candidate.name}\" (#{@candidate.email}) was successfully created."
    else
      render :action => 'new'
    end
  rescue ActiveRecord::RecordNotFound
    return render :text => "", :alert => 'Invalid parameters'
  end

def new
     @openingcandidate = OpeningCandidate.new
end


def create_op_can
   a= params[:opening_candidate][:candidate_id].split(/,/)
   cid = params[:opening_candidate][:opening_id]
 #  puts cid
 #  puts a.to_s
   new_string = ""
   cid.each do |cid|
   if cid.empty?
   else
      puts cid
      a.each do |a| 
         new_string=new_string+"{\"candidate_id\":\""+a+"\",\"opening_id\":\""+cid.to_s+"\",\"status\":\"0\"},"
      end
   end
end
#new_records = [
#  {:opening_id => 1111, :candidate_id => 2222,:status=>0}, 
#  {:opening_id => 1118, :candidate_id => 2222,:status=>0} 
#]
new_records = new_string.chomp(",")
new_records = "["+new_records+"]"
#new_records = "{\"opening_id\":\"14\",\"candidate_id\":\"14\",\"status\":\"0\"}"

         @opencandidate =  OpeningCandidate.where("candidate_id = ? ",a)
         if @opencandidate.blank?
            if OpeningCandidate.create(JSON(new_records))
               redirect_to "/candidates",  :notice => "Candidate was recommended successfully  ." 
            end
         else
            redirect_to "/candidates", :notice => "Candidate was recommended successfully before."               
         end
end


  def create_opening
    return redirect_to request.referrer, :alert => 'Invalid attributes' unless params[:candidate]
    @candidate = Candidate.find params[:id]
    authorize! :update, @candidate
    new_opening_id = params[:candidate][:opening_id].to_i
    return redirect_to request.referrer, :alert => "Opening was not given." if new_opening_id == 0
    opening_candidate = @candidate.opening_candidates.where(:opening_id => new_opening_id).first_or_create
    opening_candidate.update_candidate if opening_candidate
    redirect_to request.referrer, :notice => "Opening was successfully assigned."
  rescue ActiveRecord::RecordNotFound
    redirect_to candidates_url, :alert => 'Invalid Candidate'
  end

  # Don't support remove JD assignment via update API
  # To avoid removing a JD assignment accidentally, should use 'create_opening' instead.
  def update
    return redirect_to @candidate, :alert => 'Invalid parameters' unless params[:candidate]
    @candidate = Candidate.find params[:id]
    params[:candidate].delete(:department_id)
    params[:candidate].delete(:opening_id)

    
     tempio = nil
    unless params[:candidate][:resume].blank?
      tempio = params[:candidate][:resume]
      params[:candidate].delete(:resume)
      filename = Time.now.to_i.to_s+tempio.original_filename.force_encoding("UTF-8")
       @candidate.description = filename
       @candidate.path = 'public/uploads/'+ filename
       @candidate.upload(@candidate.path, tempio)
    end
     
     OpeningCandidate.transaction do
     #update opening_candidate 
        if  !params[:candidate][:openingid].blank?
          oldOpeningid = @candidate.openingid
          newOpeningid = params[:candidate][:openingid]
          openingcandidate = OpeningCandidate.where("candidate_id = ?" , @candidate.id)
          newOpening = Opening.where("id = ?",newOpeningid)
          oldOpening = Opening.where("id = ?",oldOpeningid)
          if @candidate.status == 2 && newOpening[0].filled_no >= newOpening[0].total_no
            redirect_to candidates_url, :alert => 'This candidate has been made offer,and the target Opening is reached to full.'
            return
          end 
          if !openingcandidate.nil?
            OpeningCandidate.update(openingcandidate,:opening_id =>newOpeningid)
            if @candidate.status == 2
              Opening.update(newOpening, :filled_no => newOpening[0].filled_no+1)
              Opening.update(oldOpening, :filled_no => oldOpening[0].filled_no-1)
            end
          end
        end

 
    if @candidate.update_attributes(params[:candidate])
      unless tempio.nil?
        if tempio.size > MAX_FILE_SIZE
          render :status => 400, :json => {:message => 'File size cannot be larger than 10M.'}
          return
        end

        #TODO: async large file upload
        if @candidate.resume.nil?
          @resume = @candidate.build_resume
          @resume.savefile(tempio.original_filename, tempio)
        else
          @candidate.resume.updatefile(tempio.original_filename, tempio)
        end       

      end
      redirect_to @candidate, :notice => "Candidate \"#{@candidate.name}\" (#{@candidate.email}) was successfully updated."
    else
      @resume = @candidate.resume.name unless @candidate.resume.nil?
      render :action => 'edit'
    end
    end #transaction
  rescue ActiveRecord::RecordNotFound
    redirect_to candidates_url, :alert => 'Invalid Candidate'
  end

  # In our design, we do not delete candidate physically, we just mark the candidate
  # to be 'inactive' in database.
  def move_to_blacklist
    @candidate = Candidate.find(params[:id])
    authorize! :manage, @candidate

    reason = params[:comments]
    @candidate.mark_inactive(reason)

    redirect_to request.referer, :notice => "Candidate \"#{@candidate.name}\" (#{@candidate.email}) was successfully moved to blacklist."
  rescue ActiveRecord::RecordNotFound
    redirect_to candidates_url, :alert => 'Invalid user'
  rescue
    redirect_to candidates_url, :error => "Candidate \"#{@candidate.name}\" (#{@candidate.email}) cannot be moved to blacklist."
  end

  def reactivate
    @candidate = Candidate.find(params[:id])
    authorize! :manage, @candidate

    @candidate.mark_active

    redirect_to request.referer, :notice => "Candidate \"#{@candidate.name}\" (#{@candidate.email}) was successfully reactived."
  rescue ActiveRecord::RecordNotFound
    redirect_to candidates_url, :alert => 'Invalid user'
  rescue
    redirect_to candidates_url, :error => "Candidate \"#{@candidate.name}\" (#{@candidate.email}) cannot be reactived."
  end

  # NOTE: keep the destroy method since we are not sure whether it is needed or not
  def destroy
    @candidate = Candidate.find(params[:id])
    @resume = @candidate.resume
    @resume.deletefile unless @resume.nil?
    @candidate.destroy

    redirect_to candidates_url, :notice => "Candidate \"#{@candidate.name}\" (#{@candidate.email}) was successfully deleted."
  rescue ActiveRecord::RecordNotFound
    redirect_to candidates_url, :alert => 'Invalid user'
  rescue
    redirect_to candidates_url, :error => "Candidate \"#{@candidate.name}\" (#{@candidate.email}) cannot be deleted."
  end

  def resume
    @candidate = Candidate.find params[:id]

    unless @candidate.nil?
      download_file(@candidate.path)
    end
  end

private
  def get_assigned_departments(candidate)
    opening_candidates = candidate.opening_candidates
    # NOTE: Currently one candidate cannot be assigned to multiple opening jobs on web UI
    assigned_departments = []
    if opening_candidates.size > 0
      opening_id = opening_candidates[0].opening_id
      assigned_departments = Department.joins(:openings).where( "openings.id = ?", opening_id )
    end
    assigned_departments
  end

  def download_folder
    folder = Rails.root.join('public', 'download')
    Dir.mkdir(folder) unless File.exists?(folder)
    folder
  end

  def download_file(filepath)
    mimetype = MIME::Types.type_for(filepath)
    filename = File.basename(filepath)
    File.open(filepath) do |fp|
      send_data(fp.read, :filename => filename, :type => "#{mimetype[0]}", :disposition => "inline")
    end
    #File.delete(filepath)
  end
 

end
