
/*   some color related routines found on the SL wiki */

/*//--                       Anti-License Text                         --//*/
/*//     Contributed Freely to the Public Domain without limitation.     //*/
/*//   2011 (CC0) [ http://creativecommons.org/publicdomain/zero/1.0 ]   //*/
/*//  Void Singer [ https://wiki.secondlife.com/wiki/User:Void_Singer ]  //*/
/*//--                                                                 --//*/

vector HSL2RGB( vector vColHSL ){ //-- <H, S, L>
    vector vColRGB;
    if (vColHSL.y > 0){
        vColRGB.x = (1.0 - llFabs( 2 * vColHSL.z - 1.0 )) * vColHSL.y;                                             //-- C
        vColHSL.x = vColHSL.x * 6.0;                                                                               //-- H'
        vColRGB.y = vColRGB.x * (1.0 - llFabs( (integer)vColHSL.x % 2 + (vColHSL.x - (integer)vColHSL.x) - 1.0 )); //-- X
        vColRGB = llList2Vector( [<vColRGB.x, vColRGB.y, vColRGB.z>,
                                  <vColRGB.y, vColRGB.x, vColRGB.z>,
                                  <vColRGB.z, vColRGB.x, vColRGB.y>,
                                  <vColRGB.z, vColRGB.y, vColRGB.x>,
                                  <vColRGB.y, vColRGB.z, vColRGB.x>,
                                  <vColRGB.x, vColRGB.z, vColRGB.y>],
                                 (integer)vColHSL.x % 6 ) + (vColHSL.z - 0.5 * vColRGB.x) * <1.0, 1.0, 1.0>;
    }else{
        vColRGB.x = vColHSL.z; //-- greyscale
        vColRGB.x = vColHSL.z; //-- greyscale
        vColRGB.x = vColHSL.z; //-- greyscale
    }
    return vColRGB;
}


vector RGB2HSL( vector vColRGB ){
    vector vColHSL = vColRGB;
    if (vColHSL.x < vColHSL.y){
        vColHSL = <vColHSL.y, vColHSL.x, vColHSL.z>;
    }
    if (vColHSL.x < vColHSL.z){
        vColHSL = <vColHSL.z, vColHSL.y, vColHSL.x>;
    }else if (vColHSL.y > vColHSL.z){
        vColHSL = <vColHSL.x, vColHSL.z, vColHSL.y>;
    }
    vColHSL.z = (vColHSL.x + vColHSL.y) * 0.5; //-- L
    vColHSL.y = vColHSL.x - vColHSL.y;         //-- C
    if (vColHSL.y>0){
        vColHSL.x = llList2Float( [(vColRGB.y - vColRGB.z) / vColHSL.y + 6.0 * (vColRGB.z > vColRGB.y),
                                   (vColRGB.z - vColRGB.x) / vColHSL.y + 2.0,
                                   (vColRGB.x - vColRGB.y) / vColHSL.y + 4.0],
                                  llListFindList( [vColRGB.x, vColRGB.y, vColRGB.z], (list)vColHSL.x  ) ) / 6.0; //-- H
        vColHSL.y = vColHSL.y / llList2Float( [2.0 * vColHSL.z, 2.0 - 2.0 * vColHSL.z], vColHSL.z > 0.5 );       //-- S
    }else{
        vColHSL.x = vColHSL.y; //-- Greyscale
    }
    return vColHSL;
}


integer ColorAlphatoRGBA(vector color, float alpha) {
    return (((integer)(alpha   * 255.0) & 0xFF) << 24) |
           (((integer)(color.x * 255.0) & 0xFF) << 16) |
           (((integer)(color.y * 255.0) & 0xFF) << 8) |
            ((integer)(color.z * 255.0) & 0xFF);
}

vector RGBAtoColor(integer rgba) {
    return < (rgba >> 16) & 0xFF, (rgba >> 8) & 0xFF, (rgba & 0xFF) > / 255.0;
}

float RGBAtoAlpha(integer rgba) {
    return ((rgba >> 24) & 0xFF) / 255.0;
}