class CommentsController < ApplicationController

before_filter :require_login

   def create
      @comment = Comment.new(params[:comment])
      openingcandidate = OpeningCandidate.where("id = " + @comment.opening_candidate_id.to_s)
      candidate = Candidate.where("id = " + openingcandidate[0].candidate_id.to_s )
      if candidate[0].openingid == -1
        redirect_to  "/candidates", :alert => "This candidate has already been removed."
        return 
      end
      if candidate[0].rating > 0
        if @comment.ext1 == 1 #differentiate pages.
         redirect_to  "/openings/opening_detail/"+openingcandidate[0].opening_id.to_s ,:alert => "Comment candidate \"#{candidate[0].name}\" unsuccessfully,because the status of candidate is locked.If you want to comment this candidate,please unlocked first."
        elsif @comment.ext1 == 2
         redirect_to  "/candidates",:alert => "Comment candidate \"#{candidate[0].name}\" unsuccessfully,because the status of candidate is locked.If you want to comment this candidate,please unlocked first."
        end
        return
      end
 
      if @comment.comment == "Type your comment,250 characters only."
       @comment.comment ="No comment"
      end
      @comment.ext2 = current_user.id
      interviewer = Interviewer.where("interview_id=? and user_id = ?",@comment.opening_candidate_id.to_s,current_user.id)
      if interviewer.empty?
          if @comment.ext1 == 1
           redirect_to  "/openings/opening_detail/"+openingcandidate[0].opening_id.to_s ,:alert => "This candidate was not delegated to you.So,you could not comment for the candidate.Furthermore, you could view who was delegated to this candidate via 'Delegate' button."
          elsif @comment.ext1 == 2
           redirect_to  "/candidates",:alert => "This candidate was not delegated to you.So,you could not comment for the candidate.Furthermore, you could view who was delegated to this candidate via 'Delegate' button." 
          end
        return
      end 
      Comment.transaction do
        @comment.save
        Interviewer.update(interviewer[0],:state => 2)
      end
      if @comment.ext1 == 1
      redirect_to  "/openings/opening_detail/"+openingcandidate[0].opening_id.to_s ,:notice => "Comment candidate \"#{candidate[0].name}\" successfully."
      elsif @comment.ext1 == 2
      redirect_to  "/candidates",:notice => "Comment candidate \"#{candidate[0].name}\" successfully."
      end
      rescue ActiveRecord::RecordNotFound
      redirect_to @comment.ext3.to_s, :alert => 'Comment failed.'
  end

  def show
     @openingcandidate = OpeningCandidate.find(params[:id])
     @comments = Comment.find(:all,:conditions => "opening_candidate_id ="+ @openingcandidate.id.to_s)
     @candidate = Candidate.find(:first, :conditions => "id = "+@openingcandidate.candidate_id.to_s )
     if @candidate.openingid == -1
        redirect_to  "/candidates", :alert => "This candidate has already been removed."
        return
      end
     render "/comments/index"
     rescue ActiveRecord::RecordNotFound
     redirect_to "/openings", :alert => 'No existing page.'
      
  end


end
