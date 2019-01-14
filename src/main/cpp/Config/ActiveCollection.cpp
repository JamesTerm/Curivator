/****************************** Header ******************************\
Class Name: ActiveCollection
File Name:	ActiveCollection.cpp
Summary: Stores all Components on the robot controlled by the software.
Project:     BroncBotzFRC2019
Copyright (c) BroncBotz.
All rights reserved.

Author(s): Ryan Cooper
Email: cooper.ryan@centaurisoftware.co
\********************************************************************/

#include <iostream>

#include "ActiveCollection.h"

using namespace std;
using namespace Configuration;

/**
 * Default Constructor
**/
ActiveCollection::ActiveCollection(){}

/**
 * Method to return a NativeComponent of a certain type and name
**/

NativeComponent* ActiveCollection::Get(string name){
	try{
		for(int i=0; i<(int)activeCollection.size();i++)
			if((*activeCollection[i]).name == (string)name)
				return activeCollection[i];
		throw "AHHH";
	}
	catch(...){
		cout << "Cannot find component " << name << ", it does not exist in the active collection!\nCheck your type correlation!" << endl;
	}
}

/**
 * Method to return a VictorSP of a certain name
**/
VictorSPItem* ActiveCollection::GetVictor(string name){
	try{
		for(int i=0; i<(int)activeCollection.size();i++){
			if((*activeCollection[i]).name == (string)name){
				return (VictorSPItem*)activeCollection[i];
			}
		}
		throw "AHHH";
	}
	catch(...){
		cout << "Cannot find victor " << name << ", it does not exist in the active collection!\n" << endl;
	}
}

/**
 * Method to return a TalonSRX of a certain name
**/
TalonSRXItem* ActiveCollection::GetTalon(string name){
	try{
		for(int i=0; i<(int)activeCollection.size();i++){
			if((*activeCollection[i]).name == (string)name){
				return (TalonSRXItem*)activeCollection[i];
			}
		}
		throw "AHHH";
	}
	catch(...){
		cout << "Cannot find talon " << name << ", it does not exist in the active collection!\n" << endl;
	}
}

/**
 * Method to return an Encoder of a certain name
**/
EncoderItem* ActiveCollection::GetEncoder(string name){
	try{
		for(int i=0; i<(int)activeCollection.size();i++){
			if((*activeCollection[i]).name == (string)name){
				return (EncoderItem*)activeCollection[i];
			}
		}
		throw "AHHH";
	}
	catch(...){
		cout << "Cannot find encoder " << name << ", it does not exist in the active collection!\n" << endl;
	}
}

/**
 * Method to return the NavX
**/
NavX* ActiveCollection::GetNavX(){
	try{
		for(int i=0; i<(int)activeCollection.size();i++){
			if((*activeCollection[i]).name == "NavX"){
				return (NavX*)activeCollection[i];
			}
		}
		throw "AHHH";
	}
	catch(...){
		cout << "Cannot find the NavX, check the config." << endl;
	}
}

/**
 * Method to return the current size of the ActiveCollection list
**/
int ActiveCollection::GetSize(){
	return activeCollection.size();
}

/**
 * Adds a component to the ActiveCollection
**/
void ActiveCollection::Add(NativeComponent *component){
	try{
		activeCollection.push_back(component);
	}
	catch(...){
		cout << "Cannot add component " << (*component).name << endl;
	}
}

vector<NativeComponent*> ActiveCollection::GetRawComponent(){
	return activeCollection;
}
