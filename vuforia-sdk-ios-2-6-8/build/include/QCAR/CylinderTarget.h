/*==============================================================================
Copyright (c) 2013 QUALCOMM Austria Research Center GmbH.
All Rights Reserved.
Proprietary - QUALCOMM Austria Research Center GmbH.

@file 
    CylinderTarget.h

@brief
    Header file for CylinderTarget class.
==============================================================================*/
#ifndef _QCAR_CylinderTarget_H_
#define _QCAR_CylinderTarget_H_

// Include files
#include <QCAR/Trackable.h>

namespace QCAR
{

/// A 3D trackable object of cylindrical or conical shape.
/**
 *  The CylinderTarget class exposes convenience functionality for setting the
 *  scene size of the object via any of its three defining geometric parameters:
 *  side length, top diameter and bottom diameter. 
 *  The object is always scaled uniformly, so changing any of its parameters 
 *  affects all others.
 */
class QCAR_API CylinderTarget : public Trackable
{
public:
        
    /// Returns the side length of the cylinder target (in 3D scene units).
    virtual float getSideLength() const = 0;

    /// Sets the side length of the cylinder target (in 3D scene units).
    /**
     *  Note that the top and bottom diameter will be scaled accordingly.
     */
    virtual bool setSideLength(float sideLength) = 0;

    /// Returns the top diameter of the cylinder target (in 3D scene units).
    virtual float getTopDiameter() const = 0;

    /// Sets the top diameter of the cylinder target (in 3D scene units).
    /**
     *  Note that the height and bottom diameter will be scaled accordingly.
     */
    virtual bool setTopDiameter(float topDiameter) = 0;

    /// Returns the bottom diameter of the cylinder target (in 3D scene units).
    virtual float getBottomDiameter() const = 0;

    /// Sets the bottom diameter of the cylinder target (in 3D scene units).
    /**
     *  Note that the height and top diameter will be scaled accordingly.
     */
    virtual bool setBottomDiameter(float bottomDiameter) = 0;

    /// Returns the system-wide unique id of the target.
    /**
     *  The target id uniquely identifies an CylinderTarget across multiple
     *  QCAR sessions. The system wide unique id may be generated off-line.
     *  This is opposed to the function getId() which is a dynamically
     *  generated id and which uniquely identifies a Trackable within one run
     *  of QCAR only.
     */
    virtual const char* getUniqueTargetId() const = 0;

};

} // namespace QCAR

#endif //_QCAR_CylinderTarget_H_
