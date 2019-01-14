/****************************** Header ******************************\
Class Name:	AxisControl inherits ControlItem
File Name:	AxisControl.cpp
Summary:	Interface for an axis control.
Project:     BroncBotzFRC2019
Copyright (c) BroncBotz.
All rights reserved.

Author(s):	Dylan Watson
Email:	dylantrwatson@gmail.com
\*********************************************************************/


#include <cmath>
#include <iostream>

#include "AxisControl.h"
#include "..\Util\Constants.h"

using namespace std;
using namespace Util;
using namespace Controls;

AxisControl::AxisControl() { }

AxisControl::AxisControl(Joystick *_joy, string _name, int _axis, double _deadZone, bool _reversed, double _powerMultiplier)
	: ControlItem(_joy, _name, _reversed, _powerMultiplier)
{
	axis = _axis;
	deadZone = _deadZone;
	previousSign = 0;
}

double AxisControl::Update()
{
	double raw = (*joy).GetRawAxis(axis);
	double dz = deadZone + MINIMUM_JOYSTICK_RETURN;
	double val = ((abs(raw) - dz) * (pow(1-dz, -1)) * getSign(raw)) * powerMultiplier;

	if(reversed)
		val = -val;

	cout << "VAL: " << val << endl;
	SetToComponents(val);
	isIdle = false;
	currentPow = val;
	previousSign = getSign(val);
	return val;
}

int AxisControl::getSign(double val)
{
	if(val < 0)
		return -1;
	else
		return 1;
}

AxisControl::~AxisControl() { }

