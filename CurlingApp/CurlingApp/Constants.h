//
//  Constants.h
//  CurlingApp
//
//  Created by Artem Lomov on 14/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

static float const CURStoneSizeDivider = 8.;
static int const CURShowGameManagerNumberOfStonesPerEnd = 16;
static int const CURNetworkManagerDropboxSuccessStatusCode = 200;
static CGFloat const CURUIIndent = 10.;
static int const CURBigFontSize = 30;
static int const CURMediumFontSize = 23;
static int const CURSmallFontSize = 20;
static CGFloat const CURScoreViewLabelSize = 60.;
static CGFloat const CURScoreViewStoneImageSize = 30.;
static int const CURScoreViewMaximumScore = 8;
static float const CURCreateGameViewControllerFieldHeight = 40;
static float const CURSettingsTransitionDuration = 0.5;
static float const CURTabBarHeight = 64.;

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) \
    ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#endif
