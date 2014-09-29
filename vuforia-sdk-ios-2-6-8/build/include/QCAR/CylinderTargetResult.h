/*==============================================================================
Copyright (c) 2013 QUALCOMM Austria Research Center GmbH.
All Rights Reserved.
Proprietary - QUALCOMM Austria Research Center GmbH.

@file 
    CylinderTargetResult.h

@brief
    Header file for CylinderTargetResult class.
==============================================================================*/
#ifndef _QCAR_CYLINDERTARGETRESULT_H_
#define _QCAR_CYLINDERTARGETRESULT_H_

// Include files
#include <QCAR/TrackableResult.h>
#include <QCAR/CylinderTarget.h>

namespace QCAR
{

/// Result for a CylinderTarget.
class QCAR_API CylinderTargetResult : public TrackableResult
{
public:

    /// Returns the corresponding Trackable that this result represents
    virtual const CylinderTarget& getTrackable() const = 0;
};

} // namespace QCAR

#endif //_QCAR_CYLINDERTARGETRESULT_H_
