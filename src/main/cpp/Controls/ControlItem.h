/****************************** Header ******************************\
Class Name:	ControlItem
File Name:	ControlItem.h
Summary:	Abstraction for managing all driver and operator controls
Project:     BroncBotzFRC2019
Copyright (c) BroncBotz.
All rights reserved.

Author(s):	Dylan Watson
Email:	dylantrwatson@gmail.com
\*********************************************************************/

#ifndef SRC_CONTROLS_CONTROLITEM_H_
#define SRC_CONTROLS_CONTROLITEM_H_

#include <frc/WPILib.h>
#include <vector>

#include "../util/Constants.h" 
#include "../Components/OutputComponent.h"

using namespace frc;
using namespace std;
using namespace Util;
using namespace Components;

namespace Controls
{
	class ControlItem 
	{
		protected:
			Joystick *joy;
			string name;
			bool reversed;
			double powerMultiplier;
			vector<OutputComponent*> components;

		public:
			ControlItem();
			ControlItem(Joystick *_joy, string _name, bool _reversed, double _powerMultiplier);
			virtual double Update() = 0;
			void AddComponent(OutputComponent *component);
			vector<string> GetComponents();
			void SetToComponents(double val);
			virtual ~ControlItem();
	};
}

#endif /* SRC_CONTROLS_CONTROLITEM_H_ */
