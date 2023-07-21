//
//  HDR.ci.metal
//  Dplayer
//
//  Created by sidney on 2022/2/12.
//

#include <metal_stdlib>
#include <CoreImage/CoreImage.h> // includes CIKernelMetalLib.h
using namespace metal;

extern "C" float4 HDRHighlight(coreimage::sample_t s, float time, coreimage::destination dest)
{
    float diagLine = dest.coord().x + dest.coord().y;
    float patternWidth = 1;
    float zebra = fract(diagLine/patternWidth + time*2.0);
    
    if ((zebra > 0.5) && (s.r > 1 || s.g > 1 || s.b > 1))
        return float4(1.0, 1.0, 1.0, 1.0);
    else
        return s;
}
