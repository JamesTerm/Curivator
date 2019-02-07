/****************************** Header ******************************\
Class Name: Robot inherits SampleRobot
File Name: Robot.cpp
Summary: Entry point from WPIlib, main class where robot routines are
started.
Project: BroncBotzFRC2019
Copyright (c) BroncBotz.
All rights reserved.

Author(s): Ryan Cooper, Dylan Watson, Chris Weeks
Email: cooper.ryan@centaurisoftware.co, dylantrwatson@gmail.com, 
chrisrweeks@aol.com
\********************************************************************/

#include <iostream>
#include "Robot.h"
//TODO: Potentiometer include, VictorSPX include
using namespace std;

/*
 * Constructor
 */
Robot::Robot()
{
	m_drive = new Drive();
	m_activeCollection = new ActiveCollection();
}

Robot::~Robot()
{
	delete m_drive;
	m_drive = nullptr;
	delete m_activeCollection;
	m_activeCollection = nullptr;
}

/*
 * Initialization method of the robot
 * This runs right after Robot() when the code is started
 * Creates Config
 */
void Robot::RobotInit()
{

	cout << "Program Version: " << VERSION << " Revision: " << REVISION << endl;
	//CameraServer::GetInstance()->StartAutomaticCapture();
	Config *config = new Config(m_activeCollection, m_drive); //!< Pointer to the configuration file of the robot
	//Must have this for smartdashboard to work properly
	SmartDashboard::init();
	m_Robot.AutonMain_init("FRC2019Robot.lua", m_activeCollection);
}

/*
 * Method that runs at the beginning of the autonomous mode
 * Uses the SmartDashboard to select the proper Autonomous mode to run
  TODO: Integrate with our dashboad; Integrate with TeleOp for sandstorm; make everything that should be abstract is in fact abstract; Integrate vision overlay and drive cam to dashboard; Write teleop goals;
 */

void Robot::Autonomous()
{
}

/*
 * Called when teleop starts
 */
void Robot::OperatorControl()
{
	#if 0
	cout << "Teleoperation Started." << endl;
	while (IsOperatorControl() && !IsDisabled())
	{
		m_drive->Update();
		Wait(0.010);
	}
	#else
	double LastTime = GetTime();
	//We can test teleop auton goals here a bit later
	while (IsOperatorControl() && !IsDisabled())
	{
		const double CurrentTime = GetTime();
		const double DeltaTime = CurrentTime - LastTime;
		LastTime = CurrentTime;
		if (DeltaTime == 0.0) continue;  //never send 0 time
		//printf("DeltaTime=%.2f\n",DeltaTime);
		#ifndef _Win32
		m_Robot.Update(DeltaTime);
		#else
		m_Robot.Update(0.01);  //It's best to use sythetic time for simulation to step through code
		#endif
		//using this from test runs from robo wranglers code
		Wait(0.010);
	}
	#endif
}

/*
 * Called when the Test period starts
 */
void Robot::Test()
{
}

START_ROBOT_CLASS(Robot) //!< This identifies Robot as the main Robot starting class
