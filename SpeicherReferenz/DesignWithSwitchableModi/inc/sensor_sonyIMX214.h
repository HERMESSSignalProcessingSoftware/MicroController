#ifndef _INCLUDED_SENSOR_SONYIMX214_H_
#define _INCLUDED_SENSOR_SONYIMX214_H_

#include <cyu3types.h>


typedef struct
{
  uint16_t analogGainGlobal;
  uint16_t digitalGainGreen;
  uint16_t digitalGainRed;
  uint16_t digitalGainBlue;
  uint16_t digitalGainGb;
  uint16_t analogueGainGlobal;
} SensorSonyIMX214Gain;

typedef struct
{
  uint16_t resolutionHorizontalContainerSize;
  uint16_t resolutionVerticalContainerSize;
  uint16_t uint16_xleftCorner;
  uint16_t uint16_yleftCorner;
  uint16_t uint16_xrightCorner;
  uint16_t uint16_yrightCorner;
  uint8_t binningMode;
  uint8_t binningWeighting;
  uint8_t bitDepth;
  uint32_t dataRate;
  uint16_t horizontalSize;
  uint16_t verticalSize;
  uint16_t coarseIntegTime;
  SensorSonyIMX214Gain gain;
} SensorSonyIMX214InitParam;


CyU3PReturnStatus_t
SensorSonyIMX214WriteOneByte
(
    uint16_t Addr,
    uint8_t buf
);

CyU3PReturnStatus_t
SensorSonyIMX214WriteXByte
(
    uint16_t Addr,
    uint8_t count,
    uint8_t *buf
);

CyU3PReturnStatus_t
SensorSonyIMX214SoftwareReset
(
  void
);

void
SensorSonyIMX214CSILANEMODE
(
  void
);

void
SensorSonyIMX214MipiCLKModi
(
  void
);

void
SensorSonyIMX214HDRCaptureMode
(
  void
);

void
SensorSonyIMX214ImageAreaDeterminationSetting
(
  uint16_t uint16_xleftCorner, uint16_t uint16_yleftCorner,
  uint16_t uint16_xrightCorner, uint16_t uint16_yrightCorner
);

void
SensorSonyIMX214SubSamplingMode
(
  void
);

void
SensorSonyIMX214BinningMode
(
  uint8_t binningMode,
  uint8_t binningWeighting
);

void
SensorSonyIMX214ManufactureSpecifiedRegister
(
  void
);

void
SensorSonyIMX214BitDepth
(
  uint8_t bitDepth
);

void
SensorSonyIMX214setTotalFrameContainerSize
(
  uint16_t horizontalSize,
  uint16_t verticalSize
);

void
SensorSonyIMX214OutputCropSettings
(
  uint16_t horizontalSize,
  uint16_t verticalSize
);

void
SensorSonyIMX214ScallingMode
(
  void
);

void
SensorSonyIMX214DigitalCrop
(
  uint16_t horizontalSize,
  uint16_t verticalSize
);

void
SensorSonyIMX214PLLSettings
(
  void
);

void
SensorSonyIMX214DataRateSettings
(
  uint32_t dataRate
);

void
SensorSonyIMX214ShadingCorrectionDisable
(
  void
);

void
SensorSonyIMX214GreenImbalanceFilterDisable
(
  void
);

void
SensorSonyIMX214GreenImbalanceFilterWeight
(
  void
);

void
SensorSonyIMX214BlackLevelCorrectionDisable
(
  void
);

void
SensorSonyIMX214MappingCoupletCorrectDisable
(
  void
);

void
SensorSonyIMX214SingleDefectCorrectDisable
(
  void
);

void
SensorSonyIMX214RMSC_NR_MODEdisable
(
  void
);

void
SensorSonyIMX214StatsEnable
(
  void
);

void
SensorSonyIMX214StatsSettings
(
  uint16_t horizontalSize
);

void
SensorSonyIMX214ElectronicShutterSetting
(
  uint16_t coarseIntegTime
);

void
SensorSonyIMX214AnalogGainGlobal
(
  uint16_t analogGainGlobal
);

void
SensorSonyIMX214digitalGainGreen
(
  uint16_t digitalGainGreen
);

void
SensorSonyIMX214digitalGainRed
(
  uint16_t digitalGainRed
);

void
SensorSonyIMX214digitalGainBlue
(
  uint16_t digitalGainBlue
);

void
SensorSonyIMX214digitalGainGb
(
  uint16_t digitalGainGb
);

void
SensorSonyIMX214ShortAnalogueGainGlobal
(
  uint16_t analogueGainGlobal
);

void
SensorSonyIMX214StartingStreaming
(
    void
);

void
SensorSonyIMX214StopStreaming
(
    void
);

void
SensorSonyIMX214Init
(
 SensorSonyIMX214InitParam *dataIn
);

void
SensorSonyIMX214CheckSensorResolution
(
    void
);

void
SensorSonyIMX214CheckResetStatus
(
    void
);

void
SensorSonyIMX214CheckStreamingStatus
(
    void
);


void
SensorSonyIMX214CheckINCKSettings
(
    void
);

void
SensorSonyIMX214writeINCKSettings
(
    uint8_t integralOfINCK, uint8_t fractionalOfINCK
);

void
SensorSonyIMX214AnalogSettings
(
  void
);

void
SensorSonyIMX214GlobalSettings
(
  void
);

void
SensorSonyIMX214StatsDisable
(
  void
);

#endif
