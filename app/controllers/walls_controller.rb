class WallsController < ApplicationController
  before_action :set_wall, only: [:show, :edit, :update, :destroy]
  acts_as_token_authentication_handler_for User, except: [:show] 


  # GET /walls
  # GET /walls.json
  def index
    @walls = Wall.all
  end

  # GET /walls/1
  # GET /walls/1.json
  def show
    @current_wall = Wall.find(params['id'])

    @walls = user_walls
        
    @nodes = @current_wall.nodes
  end

  # GET /walls/new
  def new
    @wall = current_user.walls.new(name: 'New Wall')
  end

  # GET /walls/1/edit
  def edit
  end

  # POST /walls
  # POST /walls.json
  def create
    @wall = current_user.walls.new(wall_params)

    respond_to do |format|
      if @wall.save
        format.html { redirect_to @wall, notice: 'Wall was successfully created.' }
        format.json { render :show, status: :created, location: @wall }
      else
        format.html { render :new }
        format.json { render json: @wall.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /walls/1
  # PATCH/PUT /walls/1.json
  def update
    respond_to do |format|
      if @wall.update(wall_params)
        format.html { redirect_to @wall, notice: 'Wall was successfully updated.' }
        format.json { render :show, status: :ok, location: @wall }
      else
        format.html { render :edit }
        format.json { render json: @wall.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /walls/1
  # DELETE /walls/1.json
  def destroy
    @wall.destroy
    respond_to do |format|
      format.html { redirect_to walls_url, notice: 'Wall was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wall
      @wall = Wall.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def wall_params
      params.require(:wall).permit(:name)
    end

    # This method gets the user walls even if the user hasn't signed
    # in because is a guest
    def user_walls
      if current_user
        @walls = current_user.walls
      elsif email = params['user_email']
        @walls = User.find_by(email: email).walls
      end
    end
end
