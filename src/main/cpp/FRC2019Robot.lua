
Pi=3.14159265358979323846
Pi2=Pi*2
Inches2Meters=0.0254
Feet2Meters=0.3048
Meters2Feet=3.2808399
Meters2Inches=39.3700787
Inches2Meters=0.0254
OunceInchToNewton=0.00706155183333
Pounds2Kilograms=0.453592
Deg2Rad=(1/180) * Pi


g_wheel_diameter_in=6   --This will determine the correct distance try to make accurate too
WheelBase_Width_In=22.3125	  --The wheel base will determine the turn rate, must be as accurate as possible!
WheelBase_Length_In=9.625
WheelTurningDiameter_In= ( (WheelBase_Width_In * WheelBase_Width_In) + (WheelBase_Length_In * WheelBase_Length_In) ) ^ 0.5
HighGearSpeed = (749.3472 / 60.0) * Pi * g_wheel_diameter_in * Inches2Meters  * 0.9  --RPMs from BHS2015 Chassis.SLDASM
LowGearSpeed  = (346.6368 / 60.0) * Pi * g_wheel_diameter_in * Inches2Meters  * 0.9
GearSpeedRPM = 600  --this had 372.63 but this seemed too slow according to the encoder readings
GearSpeed = (GearSpeedRPM / 60.0) * Pi * g_wheel_diameter_in * Inches2Meters

Drive_MaxAccel=4
skid=math.cos(math.atan2(WheelBase_Length_In,WheelBase_Width_In))
gMaxTorqueYaw = (2 * Drive_MaxAccel * Meters2Inches / WheelTurningDiameter_In) * skid

MainRobot = {
	version = 1.2,
	control_assignments =
	{
		--by default module is 1, so only really need it for 2
		victor =
		{
			id_1 = { name= "right_drive_1", channel=1}, 
			id_2 = { name= "right_drive_2", channel=2}, 
			id_3 = { name= "right_drive_3", channel=3}, 
			id_4 = { name="left_drive_1", channel=4},
			id_5 = { name="left_drive_2", channel=5},
			id_6 = { name="left_drive_3", channel=6},
			id_7= { name="arm", channel=7}
			--If we decide we need more power we can assign these
		},
		-- relay =
		-- {
		-- 	id_1 = { name= "CameraLED", channel=1}
		-- },
		-- double_solenoid =
		-- {
		-- 	id_1 = { name="use_low_gear",    forward_channel=2, reverse_channel=1},
		-- 	id_2 = { name="fork_left",    forward_channel=3, reverse_channel=4},
		-- 	id_3 = { name="fork_right",    forward_channel=5, reverse_channel=6},
		-- },
		-- digital_input =
		-- {
		-- 	--These channels must be unique to digital input encoder channels as well
		-- 	--Also ensure you do not use the slot for the compressor ;)
		-- 	id_1 = { name="dart_upper_limit",  channel=5},
		-- 	id_2 = { name="dart_lower_limit",  channel=6}
		-- },
		analog_input =
		{
			id_1 = { name="arm_potentiometer",  channel=2},
		},
		digital_input_encoder =
		{	
			--encoder names must be the same name list from the victor (or other speed controls)
			--These channels must be unique to digital input channels as well
			id_1 = { name= "left_drive_1",  a_channel=3, b_channel=4},
			id_2 = { name="right_drive_1",  a_channel=1, b_channel=2},
		},
		compressor	=	{ relay=8, limit=14 },
		accelerometer	=	{ gRange=1 }
	},
	--Version helps to identify a positive update to lua
	--version = 1;
	
	Mass = 25, -- Weight kg
	MaxAccelLeft = 20, MaxAccelRight = 20, 
	MaxAccelForward = Drive_MaxAccel, MaxAccelReverse = Drive_MaxAccel, 
	MaxAccelForward_High = Drive_MaxAccel * 2, MaxAccelReverse_High = Drive_MaxAccel * 2, 
	MaxTorqueYaw =  gMaxTorqueYaw,  --Note Bradley had 0.78 reduction to get the feel
	MaxTorqueYaw_High = gMaxTorqueYaw * 5,
	MaxTorqueYaw_SetPoint = gMaxTorqueYaw * 2,
	MaxTorqueYaw_SetPoint_High = gMaxTorqueYaw * 10,
	rotation_tolerance=Deg2Rad * 2,
	rotation_distance_scalar=1.0,

	MAX_SPEED = HighGearSpeed,
	ACCEL = 10,    -- Thruster Acceleration m/s2 (1g = 9.8)
	BRAKE = ACCEL,     -- Brake Deceleration m/s2 (1g = 9.8)
	-- Turn Rates (radians/sec) This is always correct do not change
	heading_rad = (2 * HighGearSpeed * Meters2Inches / WheelTurningDiameter_In) * skid,
	
	Dimensions =
	{ Length=0.9525, Width=0.6477 }, --These are 37.5 x 25.5 inches (This is not used except for UI ignore)
	
	tank_drive =
	{
		is_closed=0,
		show_pid_dump='no',
		--we should turn this off in bench mark testing
		use_aggressive_stop=1,  --we are in small area want to have responsive stop
		ds_display_row=-1,
		wheel_base_dimensions =
		{length_in=WheelBase_Length_In, width_in=WheelBase_Width_In},
		
		--This encoders/PID will only be used in autonomous if we decide to go steal balls
		wheel_diameter_in = g_wheel_diameter_in,
		left_pid=
		{p=200, i=0, d=50},
		right_pid=
		{p=200, i=0, d=50},					--These should always match, but able to be made different
		latency=0.0,
		heading_latency=0.0,
		drive_to_scale=0.50,
		left_max_offset=0.0 , right_max_offset=0.0,   --Ensure both tread top speeds are aligned
		--This is obtainer from encoder RPM's of 1069.2 and Wheel RPM's 427.68 (both high and low have same ratio)
		encoder_to_wheel_ratio=0.5,			--example if encoder spins at 1069.2 multiply by this to get 427.68 (for the wheel rpm)
		voltage_multiply=1.0,				--May be reversed using -1.0
		--Note: this is only used in simulation as 884 victors were phased out, but encoder simulators still use it
		curve_voltage=
		{t4=3.1199, t3=-4.4664, t2=2.2378, t1=0.1222, c=0},
		force_voltage=
		{t4=0, t3=0, t2=0, t1=0, c=1},
		reverse_steering='no',
		 left_encoder_reversed='no',
		right_encoder_reversed='no',
		inv_max_accel = 1.0/15.0,  --solved empiracally
		forward_deadzone_left  = 0.02,
		forward_deadzone_right = 0.02,
		reverse_deadzone_left  = 0.02,
		reverse_deadzone_right = 0.02,
		motor_specs =
		{
			wheel_mass=1.5,
			cof_efficiency=1.0,
			gear_reduction=5310.0/749.3472,
			torque_on_wheel_radius=Inches2Meters * 1,
			drive_wheel_radius=Inches2Meters * 2,
			number_of_motors=2,
			
			free_speed_rpm=5310.0,
			stall_torque=2.43,
			stall_current_amp=133,
			free_current_amp=2.7
		}

	},
	robot_settings =
	{
		arm =
		{
			is_closed=0,
			show_pid_dump='n',
			ds_display_row=-1,
			use_pid_up_only='y',  --for now make the same, but this may change
			pid_up=
			{p=100, i=0, d=0},
			pid_down=
			{p=100, i=0, d=0},
			tolerance=0.5,  --in inches
			tolerance_count=1,
			voltage_multiply=1.0,			--May be reversed
			encoder_to_wheel_ratio=1.0,
			Arm_SetPotentiometerSafety=true,	
			max_speed=8.8,	--loaded max speed (see sheet) which is 2.69 rps
			accel=1.0,						--We may indeed have a two button solution (match with max accel)
			brake=1.0,
			max_accel_forward=10,			--just go with what feels right (up may need more)
			max_accel_reverse=10,
			using_range=0,					--Warning Only use range if we have a potentiometer!
			--These min/max in inch units
			max_range= 36,
			--Note the sketch used -43.33, but tests on actual assembly show -46.12
			min_range= 0,
			pot_offset=0,
			starting_position=6,
			use_aggressive_stop = 'yes',
			motor_specs =
			{
				wheel_mass=Pounds2Kilograms * 16.27,
				cof_efficiency=0.2,
				gear_reduction=1.0,
				torque_on_wheel_radius=Inches2Meters * 1.0,
				drive_wheel_radius=Inches2Meters * 2.0,
				number_of_motors=2,
				
				free_speed_rpm=84.0,
				stall_torque=10.6,
				stall_current_amp=18.6,
				free_current_amp=1.8
			}
		},
		claw =
		{
			--Note: there are no encoders here so is_closed is ignored
			tolerance=0.01,					--we need good precision
			voltage_multiply=1.0,			--May be reversed
			
			max_speed=28,
			accel=112,						--These are needed and should be high enough to grip without slip
			brake=112,
			max_accel_forward=112,
			max_accel_reverse=112
		}
	},
	controls =
	{
		Joystick_1 =
		{
			control = "logitech dual action",
			--Joystick_SetLeftVelocity = {type="joystick_analog", key=1, is_flipped=true, multiplier=1.0, filter=0.1, curve_intensity=3.0},
			--Joystick_SetRightVelocity = {type="joystick_analog", key=5, is_flipped=true, multiplier=1.0, filter=0.1, curve_intensity=3.0},
			Analog_Turn = {type="joystick_analog", key=0, is_flipped=false, multiplier=1.0, filter=0.3, curve_intensity=1.0},
			Joystick_SetCurrentSpeed_2 = {type="joystick_analog", key=1, is_flipped=true, multiplier=1.0, filter=0.1, curve_intensity=0.0},
			--scaled down to 0.5 to allow fine tuning and a good top acceleration speed (may change with the lua script tweaks)
			POV_Turn =  {type="joystick_analog", key=8, is_flipped=false, multiplier=1.0, filter=0.0, curve_intensity=0.0},
			Turn_180 = {type="joystick_button", key=7, on_off=false},
			
			Arm_SetPos0feet = {type="joystick_button", key=2, on_off=false},
			Arm_SetPos3feet = {type="joystick_button", key=1, on_off=false},
			Arm_SetPos6feet = {type="joystick_button", key=3, on_off=false},
			Arm_SetPos9feet = {type="joystick_button", key=4, on_off=false},
			Arm_SetCurrentVelocity = {type="joystick_analog", key=5, is_flipped=true, multiplier=0.6, filter=0.1, curve_intensity=3.0},
			Arm_Rist={type="joystick_button", key=5, on_off=true},
			
			--Claw_SetCurrentVelocity  --not used
			Claw_Close =	 {type="joystick_button", key=6, on_off=true},
			Claw_Grip =		 {type="joystick_button", key=8, on_off=true},
			--Claw_Squirt =	 {type="joystick_button", key=7, on_off=true},
			Robot_CloseDoor= {type="joystick_button", key=9, on_off=true}
		},
		
		Joystick_2 =
		{
			control = "airflo",
			--Joystick_SetLeftVelocity = {type="joystick_analog", key=1, is_flipped=true, multiplier=1.0, filter=0.1, curve_intensity=3.0},
			--Joystick_SetRightVelocity = {type="joystick_analog", key=2, is_flipped=true, multiplier=1.0, filter=0.1, curve_intensity=3.0},
			Analog_Turn = {type="joystick_analog", key=0, is_flipped=false, multiplier=1.0, filter=0.3, curve_intensity=1.0},
			Joystick_SetCurrentSpeed_2 = {type="joystick_analog", key=1, is_flipped=true, multiplier=1.0, filter=0.1, curve_intensity=0.0},
			--scaled down to 0.5 to allow fine tuning and a good top acceleration speed (may change with the lua script tweaks)
			POV_Turn =  {type="joystick_analog", key=8, is_flipped=false, multiplier=1.0, filter=0.0, curve_intensity=0.0},
			--Turn_180 = {type="joystick_button", key=7, on_off=false},
			
			Arm_SetPos0feet = {type="joystick_button", key=1, keyboard='y', on_off=false},
			Arm_SetPos3feet = {type="joystick_button", key=3, keyboard='u', on_off=false},
			Arm_SetPos6feet = {type="joystick_button", key=2, keyboard='l', on_off=false},
			Arm_SetPos9feet = {type="joystick_button", key=4, keyboard=';', on_off=false},
			Arm_SetCurrentVelocity = {type="joystick_analog", key=2, is_flipped=true, multiplier=0.6, filter=0.1, curve_intensity=3.0},
			Arm_Rist={type="joystick_button", key=5, keyboard='r', on_off=true},
			Arm_Advance={type="keyboard", key='k', on_off=true},
			Arm_Retract={type="keyboard", key='j', on_off=true},
			
			--Claw_SetCurrentVelocity  --not used
			Claw_Close =	 {type="joystick_button", key=6, keyboard='c', on_off=true},
			Claw_Grip =		 {type="joystick_button", key=8, keyboard='i', on_off=true},
			Claw_Squirt =	 {type="joystick_button", key=7, keyboard='h', on_off=true},
			Robot_CloseDoor= {type="joystick_button", key=9, keyboard='o', on_off=true}
		},

		Joystick_3 =
		{
			control = "gamepad f310 (controller)",
			Analog_Turn = {type="joystick_analog", key=0, is_flipped=false, multiplier=1.0, filter=0.3, curve_intensity=1.0},
			Joystick_SetCurrentSpeed_2 = {type="joystick_analog", key=1, is_flipped=true, multiplier=1.0, filter=0.1, curve_intensity=0.0},
			--scaled down to 0.5 to allow fine tuning and a good top acceleration speed (may change with the lua script tweaks)
			POV_Turn =  {type="joystick_analog", key=8, is_flipped=false, multiplier=1.0, filter=0.0, curve_intensity=0.0},
			--Turn_180 = {type="joystick_button", key=7, on_off=false},
			
			Arm_SetPos0feet = {type="joystick_button", key=1, on_off=false},
			Arm_SetPos3feet = {type="joystick_button", key=3, on_off=false},
			Arm_SetPos6feet = {type="joystick_button", key=2, on_off=false},
			Arm_SetPos9feet = {type="joystick_button", key=4, on_off=false},
			Arm_SetCurrentVelocity = {type="joystick_analog", key=4, is_flipped=true, multiplier=1.0, filter=0.1, curve_intensity=3.0},
			Arm_Rist={type="joystick_button", key=5, on_off=true},
			
			Claw_SetCurrentVelocity = {type="joystick_analog", key=2, is_flipped=true, multiplier=1.0, filter=0.1, curve_intensity=0.0},
			Claw_Close =	 {type="joystick_button", key=6, on_off=true},
			Claw_Grip =		 {type="joystick_button", key=9, on_off=true},
			Claw_Squirt =	 {type="joystick_button", key=7, on_off=true},
			Robot_CloseDoor= {type="joystick_button", key=8, on_off=true}
		},
	},
		
	UI =
	{
		Length=5, Width=5,
		TextImage="(   )\n|   |\n(-+-)\n|   |\n(   )"
	}
}

Robot2015 = MainRobot
