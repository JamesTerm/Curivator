/****************************** Header ******************************\
Class Name: ActiveCollection
File Name:	ActiveCollection.h
Summary: Stores all Components on the robot controlled by the software.
Project:     BroncBotzFRC2019
Copyright (c) BroncBotz.
All rights reserved.

Author(s): Ryan Cooper
Email: cooper.ryan@centaurisoftware.co
\********************************************************************/

#ifndef SRC_CONFIG_ACTIVECOLLECTION_H_
#define SRC_CONFIG_ACTIVECOLLECTION_H_

#include <vector>
#include <utility>

#include "../Components/VictorSPItem.h"
#include "../Components/TalonSRXItem.h"
#include "../Components/EncoderItem.h"
#include "../Components/DoubleSolenoidItem.h"
#include "../Components/NavX.h"

using namespace std;
using namespace Components;

namespace Configuration
{
	class ActiveCollection
	{
		public:
			enum ComponentType
			{
				VictorSP
			};

			ActiveCollection();
			virtual ~ActiveCollection(){}

			NativeComponent* Get(string name);
			VictorSPItem* GetVictor(string name);
			TalonSRXItem* GetTalon(string name);
			EncoderItem* GetEncoder(string name);
			NavX* GetNavX();
			int GetSize();
			vector<NativeComponent*> GetRawComponent();
			void Add(NativeComponent *component);

	private:
		vector<NativeComponent*> activeCollection;
	};
}

#endif /* SRC_CONFIG_ACTIVECOLLECTION_H_ */
