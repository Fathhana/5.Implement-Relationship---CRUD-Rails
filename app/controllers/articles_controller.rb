class ArticlesController < ApplicationController
  before_action :check_current_user, only: [:new, :create, :edit, :update, :destroy]
  def index
    @articles = Article.page(params[:page]).per(10).order("id desc")
    respond_to do |format|
      format.html
      format.csv { send_data @articles.to_csv }
      format.xls { send_data @articles.to_csv(col_sep: "\t") }
    end
  end

  def new
    @article = Article.new
  end

  def edit
  end

  def create
      @article = Article.new(params_article)
      if @article.save
          flash[:notice] = "Success Add Records"
          redirect_to action: 'index'
      else
          flash[:error] = "data not valid"
          render 'new'
      end
  end

  def show
    @article = Article.find_by_id(params[:id])
    @comments = @article.comments.order("id desc")
    @comment = Comment.new
  end

  def edit
    @article = Article.find_by_id(params[:id])
  end

  def update
    @article = Article.find_by_id(params[:id])
    if @article.update(params_article)
      flash[:notice] = "Success Update Records"
      redirect_to action: 'index'
    else
      flash[:error] = "data not valid"
      render 'edit'
    end
  end

  def destroy
      @article = Article.find_by_id(params[:id])
      if @article.destroy
          flash[:notice] = "Success Delete a Records"
          redirect_to action: 'index'
      else
          flash[:error] = "fails delete a records"
          redirect_to action: 'index'
      end
  end
  

def import
  Article.import(params[:file])
  redirect_to root_url, notice: "Articles imported."
end


  private
    def params_article
        params.require(:article).permit(:title, :content, :status)
    end
end
