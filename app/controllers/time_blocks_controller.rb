class TimeBlocksController < ApplicationController
  before_filter :parse_times_with_chronic, :only => [:create, :update]

  def parse_times_with_chronic
    h = params[:time_block]
    h[:start_time] = Chronic.parse(h[:start_time]) if h[:start_time].present?
    h[:end_time  ] = Chronic.parse(h[:end_time])   if h[:end_time].present?
    true
  end

  # GET /time_blocks
  # GET /time_blocks.xml
  def index
    @time_blocks = TimeBlock.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @time_blocks }
    end
  end

  # GET /time_blocks/1
  # GET /time_blocks/1.xml
  def show
    @time_block = TimeBlock.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @time_block }
    end
  end

  # GET /time_blocks/new
  # GET /time_blocks/new.xml
  def new
    @time_block = TimeBlock.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @time_block }
    end
  end

  # GET /time_blocks/1/edit
  def edit
    @time_block = TimeBlock.find(params[:id])
  end

  # POST /time_blocks
  # POST /time_blocks.xml
  def create
    @time_block = TimeBlock.new(params[:time_block])

    respond_to do |format|
      if @time_block.save
        flash[:notice] = 'TimeBlock was successfully created.'
        format.html { redirect_to(@time_block) }
        format.xml  { render :xml => @time_block, :status => :created, :location => @time_block }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @time_block.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /time_blocks/1
  # PUT /time_blocks/1.xml
  def update
    @time_block = TimeBlock.find(params[:id])

    respond_to do |format|
      if @time_block.update_attributes(params[:time_block])
        flash[:notice] = 'TimeBlock was successfully updated.'
        format.html {
          redirect_to [params[:redirect_on_success], @time_block].reject(&:blank?).first
        }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @time_block.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /time_blocks/1
  # DELETE /time_blocks/1.xml
  def destroy
    @time_block = TimeBlock.find(params[:id])
    @time_block.destroy

    respond_to do |format|
      format.html { redirect_to(time_blocks_url) }
      format.xml  { head :ok }
    end
  end
end
