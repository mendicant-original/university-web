class Admin::Chat::ChannelsController < Admin::Base
  before_filter :find_channel, :only => [:edit, :update, :destroy]
  
  def index
    @channels = Chat::Channel.order("name")
  end
  
  def new
    @channel = Chat::Channel.new
  end
  
  def create
    @channel = Chat::Channel.new(params[:chat_channel])
    
    if @channel.save
      flash[:notice] = "Channel sucessfully created."
      redirect_to admin_chat_channels_path
    else
      render :action => :new
    end
  end
  
  def edit
    
  end
  
  def update
    if @channel.update_attributes(params[:chat_channel])
      flash[:notice] = "Channel sucessfully updated."
      redirect_to admin_chat_channels_path
    else
      render :action => :edit
    end
  end
  
  def destroy
    @channel.destroy
    
    flash[:notice] = "Channel sucessfully destroyed."
    redirect_to admin_chat_channels_path
  end
  
  private
  
  def find_channel
    @channel = Chat::Channel.find(params[:id])
  end
end
