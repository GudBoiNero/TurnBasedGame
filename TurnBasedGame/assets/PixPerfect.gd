extends Camera2D
### Base Size of the Game ###
const BaseW = 320
const BaseH = 180
 
const black = Color(0,0,0,1)
 
### OS Size of the Window ###
var ScreenW
var ScreenH
### The Pixel Resizer ###
var MaxResize
### Camera Zoom ###
var CameraW
var CameraH 
### Black Bars ###
var BlackX
var BlackY
 
 
func _ready():
	#get the device's screen size/resolution
	ScreenW = OS.get_window_size().x
	ScreenH = OS.get_window_size().y
	
	#test print the device screen size
	#print("My Screen Size = ("+str(ScreenW)+" , "+str(ScreenH)+")")
 
 
	#get the shortest, if length or width of the screen as a basis to resize
	var compx = floor(ScreenW/BaseW)
	var compy = floor(ScreenH/BaseH)
	
	if (compx <= compy):
		MaxResize = compx
	else:
		MaxResize = compy
	
	#test print the result what ratio(real number) gonna use
	#print("My Resize = ("+str(MaxResize)+")")
 
 
	#get camera zoom to fit the screen and have a pixel perfect fit
	CameraW = (BaseW*ScreenW)/(BaseW*MaxResize)
	CameraH = (BaseH*ScreenH)/(BaseH*MaxResize)
	
	#test camera size or the base ratio
	#print("My Camera Size = ("+str(CameraW)+" , "+str(CameraH)+")")
	
	set_zoom(Vector2((CameraW/BaseW),(CameraH/BaseH)))
	
	#test get the camera zoom
	#print("My Zoom = "+str(get_zoom()))
	
	#Calculate the black bar size
	BlackX = (CameraW-BaseW)/2
	BlackY = (CameraH-BaseH)/2
	pass
 
 
#Draw the black bars on the sides to hide other elements
#you can also add other drawable elements here
#or put your Hud here for other device that have bottom space
func _draw():
	draw_rect(Rect2(Vector2(-BlackX-(BaseW/2),-(BaseH/2)),Vector2(BaseW+(BlackX*2),-BlackY)),black)
	draw_rect(Rect2(Vector2(-BlackX-(BaseW/2),(BaseH/2)),Vector2(BaseW+(BlackX*2),BlackY)),black)
	draw_rect(Rect2(Vector2(-(BaseW/2),-(BaseH/2)),Vector2(-BlackX,BaseH)),black)
	draw_rect(Rect2(Vector2((BaseW/2),-(BaseH/2)),Vector2(BlackX,BaseH)),black)
	pass
