/*
 * Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
 * for details. All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */
import "dart:html";
import "dart:math" as Math;
import "../../../testcommon.dart";

// This test should show a table of canvas elements. Onto the background of each
// a blue square is drawn, either fully opaque or with some transparency, and
// then a clip and transformation is applied. The clip only allows drawing in
// the left two thirds of the canvas.

// Once each canvas has been set up, an image is drawn with the composite mode
// for that row. Each row uses a different compositing mode. Different columns
// are used for when the background is or isn't transparent, and when the image
// is drawn with or without a global alpha.

// The image is a green rectangle which gets skewed by transform and cut off by
// the clip. In each row the green rectangle should be drawn with the
// appropriate compositing mode, as per the HTML5 canvas spec. The background on
// the right should always be left untouched due to the clip.

// These map to the rows of the table
var compositeTypes = [
  'source-over','source-in','source-out','source-atop',
  'destination-over','destination-in','destination-out','destination-atop',
  'lighter','copy','xor'
];

// These map to the columns of the table
var testNames = [
  'solid on solid', 'alpha on solid', 'solid on alpha', 'alpha on alpha'
];

// These are the points where pixel values are checked for correctness
var testPoints = [
  // points down the left edge
  {'x': 10, 'y': 3}, {'x': 10, 'y': 20}, {'x': 10, 'y': 37},
  // points outside the left edge of the image
  {'x': 33, 'y': 3}, {'x': 28, 'y': 20}, {'x': 38, 'y': 30}, {'x': 49, 'y': 37},
  // points inside the left edge of the image
  {'x': 39, 'y': 3}, {'x': 34, 'y': 20}, {'x': 48, 'y': 30}, {'x': 57, 'y': 37},
  // points inside the right edge of the image
  {'x': 56, 'y': 3}, {'x': 65, 'y': 8}, {'x': 77, 'y': 16}, {'x': 77, 'y': 30}, {'x': 77, 'y': 37},
  // points outside the right edge of the image
  {'x': 65, 'y': 3}, {'x': 74, 'y': 8},
  // points in the region that gets clipped
  {'x': 83, 'y': 3}, {'x': 83, 'y': 20}, {'x': 83, 'y': 37}, {'x': 120, 'y': 3}, {'x': 120, 'y': 20}, {'x': 120, 'y': 37},
];

var expectedColors = [
  // source-over
  [[[0, 0, 0, 0], [0, 100, 255, 255], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 255], [0, 100, 255, 255],
    [0, 0, 0, 0], [244, 233, 52, 255], [64, 255, 0, 255], [64, 255, 0, 255], [64, 255, 0, 255], [244, 233, 52, 255],
    [244, 233, 52, 255], [191, 191, 191, 255], [191, 191, 191, 255], [82, 169, 82, 255], [0, 0, 0, 0], [0, 100, 255, 255],
    [0, 0, 0, 0], [0, 100, 255, 255], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 255], [0, 0, 0, 0]],
   [[0, 0, 0, 0], [0, 100, 255, 255], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 255], [0, 100, 255, 255],
    [0, 0, 0, 0], [243, 233, 51, 128], [32, 178, 127, 255], [32, 178, 127, 255], [63, 255, 0, 128], [243, 233, 51, 128],
    [122, 167, 153, 255], [96, 146, 223, 255], [96, 146, 223, 255], [81, 169, 81, 128], [0, 0, 0, 0], [0, 100, 255, 255],
    [0, 0, 0, 0], [0, 100, 255, 255], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 255], [0, 0, 0, 0]],
   [[0, 0, 0, 0], [0, 100, 255, 127], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 127], [0, 100, 255, 127],
    [0, 0, 0, 0], [244, 233, 52, 255], [64, 255, 0, 255], [64, 255, 0, 255], [64, 255, 0, 255], [244, 233, 52, 255],
    [244, 233, 52, 255], [191, 191, 191, 255], [191, 191, 191, 255], [82, 169, 82, 255], [0, 0, 0, 0], [0, 100, 255, 127],
    [0, 0, 0, 0], [0, 100, 255, 127], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 127], [0, 0, 0, 0]],
   [[0, 0, 0, 0], [0, 100, 255, 127], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 127], [0, 100, 255, 127],
    [0, 0, 0, 0], [243, 233, 51, 128], [42, 204, 84, 191], [42, 204, 84, 191], [63, 255, 0, 128], [243, 233, 51, 128],
    [162, 189, 118, 191], [128, 161, 212, 191], [128, 161, 212, 191], [81, 169, 81, 128], [0, 0, 0, 0], [0, 100, 255, 127],
    [0, 0, 0, 0], [0, 100, 255, 127], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 127], [0, 0, 0, 0]]],
  // source-in
  [[[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0],
    [0, 0, 0, 0], [0, 0, 0, 0], [64, 255, 0, 255], [64, 255, 0, 255], [0, 0, 0, 0], [0, 0, 0, 0],
    [244, 233, 52, 255], [191, 191, 191, 255], [191, 191, 191, 255], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0],
    [0, 0, 0, 0], [0, 100, 255, 255], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 255], [0, 0, 0, 0]],
   [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0],
    [0, 0, 0, 0], [0, 0, 0, 0], [63, 255, 0, 128], [63, 255, 0, 128], [0, 0, 0, 0], [0, 0, 0, 0],
    [243, 233, 51, 128], [191, 191, 191, 128], [191, 191, 191, 128], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0],
    [0, 0, 0, 0], [0, 100, 255, 255], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 255], [0, 0, 0, 0]],
   [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0],
    [0, 0, 0, 0], [0, 0, 0, 0], [64, 255, 0, 127], [64, 255, 0, 127], [0, 0, 0, 0], [0, 0, 0, 0],
    [244, 232, 52, 127], [190, 190, 190, 127], [190, 190, 190, 127], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0],
    [0, 0, 0, 0], [0, 100, 255, 127], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 127], [0, 0, 0, 0]],
   [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0],
    [0, 0, 0, 0], [0, 0, 0, 0], [63, 255, 0, 64], [63, 255, 0, 64], [0, 0, 0, 0], [0, 0, 0, 0],
    [243, 231, 51, 64], [191, 191, 191, 64], [191, 191, 191, 64], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0],
    [0, 0, 0, 0], [0, 100, 255, 127], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 127], [0, 0, 0, 0]]],
  // source-out
  [[[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0],
    [0, 0, 0, 0], [244, 233, 52, 255], [0, 0, 0, 0], [0, 0, 0, 0], [64, 255, 0, 255], [244, 233, 52, 255],
    [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [82, 169, 82, 255], [0, 0, 0, 0], [0, 0, 0, 0],
    [0, 0, 0, 0], [0, 100, 255, 255], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 255], [0, 0, 0, 0]],
   [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0],
    [0, 0, 0, 0], [243, 233, 51, 128], [0, 0, 0, 0], [0, 0, 0, 0], [63, 255, 0, 128], [243, 233, 51, 128],
    [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [81, 169, 81, 128], [0, 0, 0, 0], [0, 0, 0, 0],
    [0, 0, 0, 0], [0, 100, 255, 255], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 255], [0, 0, 0, 0]],
   [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0],
    [0, 0, 0, 0], [244, 233, 52, 255], [63, 255, 0, 128], [63, 255, 0, 128], [64, 255, 0, 255], [244, 233, 52, 255],
    [243, 233, 51, 128], [191, 191, 191, 128], [191, 191, 191, 128], [82, 169, 82, 255], [0, 0, 0, 0], [0, 0, 0, 0],
    [0, 0, 0, 0], [0, 100, 255, 127], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 127], [0, 0, 0, 0]],
   [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0],
    [0, 0, 0, 0], [243, 233, 51, 128], [63, 255, 0, 64], [63, 255, 0, 64], [63, 255, 0, 128], [243, 233, 51, 128],
    [243, 231, 51, 64], [191, 191, 191, 64], [191, 191, 191, 64], [81, 169, 81, 128], [0, 0, 0, 0], [0, 0, 0, 0],
    [0, 0, 0, 0], [0, 100, 255, 127], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 127], [0, 0, 0, 0]]],
  // source-atop
  [[[0, 0, 0, 0], [0, 100, 255, 255], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 255], [0, 100, 255, 255],
    [0, 0, 0, 0], [0, 0, 0, 0], [64, 255, 0, 255], [64, 255, 0, 255], [0, 0, 0, 0], [0, 0, 0, 0],
    [244, 233, 52, 255], [191, 191, 191, 255], [191, 191, 191, 255], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 255],
    [0, 0, 0, 0], [0, 100, 255, 255], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 255], [0, 0, 0, 0]],
   [[0, 0, 0, 0], [0, 100, 255, 255], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 255], [0, 100, 255, 255],
    [0, 0, 0, 0], [0, 0, 0, 0], [32, 178, 127, 255], [32, 178, 127, 255], [0, 0, 0, 0], [0, 0, 0, 0],
    [122, 167, 153, 255], [96, 146, 223, 255], [96, 146, 223, 255], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 255],
    [0, 0, 0, 0], [0, 100, 255, 255], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 255], [0, 0, 0, 0]],
   [[0, 0, 0, 0], [0, 100, 255, 127], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 127], [0, 100, 255, 127],
    [0, 0, 0, 0], [0, 0, 0, 0], [64, 255, 0, 127], [64, 255, 0, 127], [0, 0, 0, 0], [0, 0, 0, 0],
    [244, 232, 52, 127], [190, 190, 190, 127], [190, 190, 190, 127], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 127],
    [0, 0, 0, 0], [0, 100, 255, 127], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 127], [0, 0, 0, 0]],
   [[0, 0, 0, 0], [0, 100, 255, 127], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 127], [0, 100, 255, 127],
    [0, 0, 0, 0], [0, 0, 0, 0], [32, 178, 126, 127], [32, 178, 126, 127], [0, 0, 0, 0], [0, 0, 0, 0],
    [122, 166, 152, 127], [96, 146, 222, 127], [96, 146, 222, 127], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 127],
    [0, 0, 0, 0], [0, 100, 255, 127], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 127], [0, 0, 0, 0]]],
  // destination-over
  [[[0, 0, 0, 0], [0, 100, 255, 255], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 255], [0, 100, 255, 255],
    [0, 0, 0, 0], [244, 233, 52, 255], [0, 100, 255, 255], [0, 100, 255, 255], [64, 255, 0, 255], [244, 233, 52, 255],
    [0, 100, 255, 255], [0, 100, 255, 255], [0, 100, 255, 255], [82, 169, 82, 255], [0, 0, 0, 0], [0, 100, 255, 255],
    [0, 0, 0, 0], [0, 100, 255, 255], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 255], [0, 0, 0, 0]],
   [[0, 0, 0, 0], [0, 100, 255, 255], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 255], [0, 100, 255, 255],
    [0, 0, 0, 0], [243, 233, 51, 128], [0, 100, 255, 255], [0, 100, 255, 255], [63, 255, 0, 128], [243, 233, 51, 128],
    [0, 100, 255, 255], [0, 100, 255, 255], [0, 100, 255, 255], [81, 169, 81, 128], [0, 0, 0, 0], [0, 100, 255, 255],
    [0, 0, 0, 0], [0, 100, 255, 255], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 255], [0, 0, 0, 0]],
   [[0, 0, 0, 0], [0, 100, 255, 127], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 127], [0, 100, 255, 127],
    [0, 0, 0, 0], [244, 233, 52, 255], [32, 178, 127, 255], [32, 178, 127, 255], [64, 255, 0, 255], [244, 233, 52, 255],
    [122, 167, 153, 255], [96, 146, 223, 255], [96, 146, 223, 255], [82, 169, 82, 255], [0, 0, 0, 0], [0, 100, 255, 127],
    [0, 0, 0, 0], [0, 100, 255, 127], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 127], [0, 0, 0, 0]],
   [[0, 0, 0, 0], [0, 100, 255, 127], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 127], [0, 100, 255, 127],
    [0, 0, 0, 0], [243, 233, 51, 128], [21, 152, 169, 191], [21, 152, 169, 191], [63, 255, 0, 128], [243, 233, 51, 128],
    [81, 144, 186, 191], [64, 130, 233, 191], [64, 130, 233, 191], [81, 169, 81, 128], [0, 0, 0, 0], [0, 100, 255, 127],
    [0, 0, 0, 0], [0, 100, 255, 127], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 127], [0, 0, 0, 0]]],
  // destination-in
  [[[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0],
    [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 255], [0, 100, 255, 255], [0, 0, 0, 0], [0, 0, 0, 0],
    [0, 100, 255, 255], [0, 100, 255, 255], [0, 100, 255, 255], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0],
    [0, 0, 0, 0], [0, 100, 255, 255], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 255], [0, 0, 0, 0]],
   [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0],
    [0, 0, 0, 0], [0, 0, 0, 0], [0, 99, 255, 128], [0, 99, 255, 128], [0, 0, 0, 0], [0, 0, 0, 0],
    [0, 99, 255, 128], [0, 99, 255, 128], [0, 99, 255, 128], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0],
    [0, 0, 0, 0], [0, 100, 255, 255], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 255], [0, 0, 0, 0]],
   [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0],
    [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 127], [0, 100, 255, 127], [0, 0, 0, 0], [0, 0, 0, 0],
    [0, 100, 255, 127], [0, 100, 255, 127], [0, 100, 255, 127], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0],
    [0, 0, 0, 0], [0, 100, 255, 127], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 127], [0, 0, 0, 0]],
   [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0],
    [0, 0, 0, 0], [0, 0, 0, 0], [0, 101, 255, 63], [0, 101, 255, 63], [0, 0, 0, 0], [0, 0, 0, 0],
    [0, 101, 255, 63], [0, 101, 255, 63], [0, 101, 255, 63], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0],
    [0, 0, 0, 0], [0, 100, 255, 127], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 127], [0, 0, 0, 0]]],
  // destination-out
  [[[0, 0, 0, 0], [0, 100, 255, 255], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 255], [0, 100, 255, 255],
    [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0],
    [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 255],
    [0, 0, 0, 0], [0, 100, 255, 255], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 255], [0, 0, 0, 0]],
   [[0, 0, 0, 0], [0, 100, 255, 255], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 255], [0, 100, 255, 255],
    [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 127], [0, 100, 255, 127], [0, 0, 0, 0], [0, 0, 0, 0],
    [0, 100, 255, 127], [0, 100, 255, 127], [0, 100, 255, 127], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 255],
    [0, 0, 0, 0], [0, 100, 255, 255], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 255], [0, 0, 0, 0]],
   [[0, 0, 0, 0], [0, 100, 255, 127], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 127], [0, 100, 255, 127],
    [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0],
    [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 127],
    [0, 0, 0, 0], [0, 100, 255, 127], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 127], [0, 0, 0, 0]],
   [[0, 0, 0, 0], [0, 100, 255, 127], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 127], [0, 100, 255, 127],
    [0, 0, 0, 0], [0, 0, 0, 0], [0, 101, 255, 63], [0, 101, 255, 63], [0, 0, 0, 0], [0, 0, 0, 0],
    [0, 101, 255, 63], [0, 101, 255, 63], [0, 101, 255, 63], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 127],
    [0, 0, 0, 0], [0, 100, 255, 127], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 127], [0, 0, 0, 0]]],
  // destination-atop
  [[[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0],
    [0, 0, 0, 0], [244, 233, 52, 255], [0, 100, 255, 255], [0, 100, 255, 255], [64, 255, 0, 255], [244, 233, 52, 255],
    [0, 100, 255, 255], [0, 100, 255, 255], [0, 100, 255, 255], [82, 169, 82, 255], [0, 0, 0, 0], [0, 0, 0, 0],
    [0, 0, 0, 0], [0, 100, 255, 255], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 255], [0, 0, 0, 0]],
   [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0],
    [0, 0, 0, 0], [243, 233, 51, 128], [0, 99, 255, 128], [0, 99, 255, 128], [63, 255, 0, 128], [243, 233, 51, 128],
    [0, 99, 255, 128], [0, 99, 255, 128], [0, 99, 255, 128], [81, 169, 81, 128], [0, 0, 0, 0], [0, 0, 0, 0],
    [0, 0, 0, 0], [0, 100, 255, 255], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 255], [0, 0, 0, 0]],
   [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0],
    [0, 0, 0, 0], [244, 233, 52, 255], [32, 178, 127, 255], [32, 178, 127, 255], [64, 255, 0, 255], [244, 233, 52, 255],
    [122, 167, 153, 255], [96, 146, 223, 255], [96, 146, 223, 255], [82, 169, 82, 255], [0, 0, 0, 0], [0, 0, 0, 0],
    [0, 0, 0, 0], [0, 100, 255, 127], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 127], [0, 0, 0, 0]],
   [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0],
    [0, 0, 0, 0], [243, 233, 51, 128], [31, 177, 127, 128], [31, 177, 127, 128], [63, 255, 0, 128], [243, 233, 51, 128],
    [121, 167, 153, 128], [95, 145, 223, 128], [95, 145, 223, 128], [81, 169, 81, 128], [0, 0, 0, 0], [0, 0, 0, 0],
    [0, 0, 0, 0], [0, 100, 255, 127], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 127], [0, 0, 0, 0]]],
  // lighter
  [[[0, 0, 0, 0], [0, 100, 255, 255], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 255], [0, 100, 255, 255],
    [0, 0, 0, 0], [244, 233, 52, 255], [64, 255, 255, 255], [64, 255, 255, 255], [64, 255, 0, 255], [244, 233, 52, 255],
    [244, 255, 255, 255], [191, 255, 255, 255], [191, 255, 255, 255], [82, 169, 82, 255], [0, 0, 0, 0], [0, 100, 255, 255],
    [0, 0, 0, 0], [0, 100, 255, 255], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 255], [0, 0, 0, 0]],
   [[0, 0, 0, 0], [0, 100, 255, 255], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 255], [0, 100, 255, 255],
    [0, 0, 0, 0], [243, 233, 51, 128], [32, 228, 255, 255], [32, 228, 255, 255], [63, 255, 0, 128], [243, 233, 51, 128],
    [122, 217, 255, 255], [96, 196, 255, 255], [96, 196, 255, 255], [81, 169, 81, 128], [0, 0, 0, 0], [0, 100, 255, 255],
    [0, 0, 0, 0], [0, 100, 255, 255], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 255], [0, 0, 0, 0]],
   [[0, 0, 0, 0], [0, 100, 255, 127], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 127], [0, 100, 255, 127],
    [0, 0, 0, 0], [244, 233, 52, 255], [64, 255, 127, 255], [64, 255, 127, 255], [64, 255, 0, 255], [244, 233, 52, 255],
    [244, 255, 179, 255], [191, 241, 255, 255], [191, 241, 255, 255], [82, 169, 82, 255], [0, 0, 0, 0], [0, 100, 255, 127],
    [0, 0, 0, 0], [0, 100, 255, 127], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 127], [0, 0, 0, 0]],
   [[0, 0, 0, 0], [0, 100, 255, 127], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 127], [0, 100, 255, 127],
    [0, 0, 0, 0], [243, 233, 51, 128], [32, 178, 127, 255], [32, 178, 127, 255], [63, 255, 0, 128], [243, 233, 51, 128],
    [122, 167, 153, 255], [96, 146, 223, 255], [96, 146, 223, 255], [81, 169, 81, 128], [0, 0, 0, 0], [0, 100, 255, 127],
    [0, 0, 0, 0], [0, 100, 255, 127], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 127], [0, 0, 0, 0]]],
  // copy
  [[[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0],
    [0, 0, 0, 0], [244, 233, 52, 255], [64, 255, 0, 255], [64, 255, 0, 255], [64, 255, 0, 255], [244, 233, 52, 255],
    [244, 233, 52, 255], [191, 191, 191, 255], [191, 191, 191, 255], [82, 169, 82, 255], [0, 0, 0, 0], [0, 0, 0, 0],
    [0, 0, 0, 0], [0, 100, 255, 255], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 255], [0, 0, 0, 0]],
   [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0],
    [0, 0, 0, 0], [243, 233, 51, 128], [63, 255, 0, 128], [63, 255, 0, 128], [63, 255, 0, 128], [243, 233, 51, 128],
    [243, 233, 51, 128], [191, 191, 191, 128], [191, 191, 191, 128], [81, 169, 81, 128], [0, 0, 0, 0], [0, 0, 0, 0],
    [0, 0, 0, 0], [0, 100, 255, 255], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 255], [0, 0, 0, 0]],
   [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0],
    [0, 0, 0, 0], [244, 233, 52, 255], [64, 255, 0, 255], [64, 255, 0, 255], [64, 255, 0, 255], [244, 233, 52, 255],
    [244, 233, 52, 255], [191, 191, 191, 255], [191, 191, 191, 255], [82, 169, 82, 255], [0, 0, 0, 0], [0, 0, 0, 0],
    [0, 0, 0, 0], [0, 100, 255, 127], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 127], [0, 0, 0, 0]],
   [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0],
    [0, 0, 0, 0], [243, 233, 51, 128], [63, 255, 0, 128], [63, 255, 0, 128], [63, 255, 0, 128], [243, 233, 51, 128],
    [243, 233, 51, 128], [191, 191, 191, 128], [191, 191, 191, 128], [81, 169, 81, 128], [0, 0, 0, 0], [0, 0, 0, 0],
    [0, 0, 0, 0], [0, 100, 255, 127], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 127], [0, 0, 0, 0]]],
  // xor
  [[[0, 0, 0, 0], [0, 100, 255, 255], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 255], [0, 100, 255, 255],
    [0, 0, 0, 0], [244, 233, 52, 255], [0, 0, 0, 0], [0, 0, 0, 0], [64, 255, 0, 255], [244, 233, 52, 255],
    [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [82, 169, 82, 255], [0, 0, 0, 0], [0, 100, 255, 255],
    [0, 0, 0, 0], [0, 100, 255, 255], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 255], [0, 0, 0, 0]],
   [[0, 0, 0, 0], [0, 100, 255, 255], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 255], [0, 100, 255, 255],
    [0, 0, 0, 0], [243, 233, 51, 128], [0, 100, 255, 127], [0, 100, 255, 127], [63, 255, 0, 128], [243, 233, 51, 128],
    [0, 100, 255, 127], [0, 100, 255, 127], [0, 100, 255, 127], [81, 169, 81, 128], [0, 0, 0, 0], [0, 100, 255, 255],
    [0, 0, 0, 0], [0, 100, 255, 255], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 255], [0, 0, 0, 0]],
   [[0, 0, 0, 0], [0, 100, 255, 127], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 127], [0, 100, 255, 127],
    [0, 0, 0, 0], [244, 233, 52, 255], [63, 255, 0, 128], [63, 255, 0, 128], [64, 255, 0, 255], [244, 233, 52, 255],
    [243, 233, 51, 128], [191, 191, 191, 128], [191, 191, 191, 128], [82, 169, 82, 255], [0, 0, 0, 0], [0, 100, 255, 127],
    [0, 0, 0, 0], [0, 100, 255, 127], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 127], [0, 0, 0, 0]],
   [[0, 0, 0, 0], [0, 100, 255, 127], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 127], [0, 100, 255, 127],
    [0, 0, 0, 0], [243, 233, 51, 128], [32, 178, 126, 127], [32, 178, 126, 127], [63, 255, 0, 128], [243, 233, 51, 128],
    [122, 168, 152, 127], [96, 146, 222, 127], [96, 146, 222, 127], [81, 169, 81, 128], [0, 0, 0, 0], [0, 100, 255, 127],
    [0, 0, 0, 0], [0, 100, 255, 127], [0, 0, 0, 0], [0, 0, 0, 0], [0, 100, 255, 127], [0, 0, 0, 0]]],
];

createOutputTable() {
  dynamic tableEl = document.getElementById('outputtable');
  var row = tableEl.insertRow(-1);
  var cell = row.insertCell(-1);
  var label;
  for (var j = 0; j < testNames.length; j++) {
    cell = row.insertCell(-1);
    label = new Text(testNames[j]);
    cell.append(label);
  }
  for (var i = 0; i < compositeTypes.length; i++) {
    row = tableEl.insertRow(-1);
    cell = row.insertCell(-1);
    label = new Text(compositeTypes[i]);
    cell.append(label);
    for (var j = 0; j < testNames.length; j++) {
      CanvasElement canvas = document.createElement('canvas');
      canvas.width = 130;
      canvas.height = 40;
      canvas.id = compositeTypes[i] + testNames[j];
      cell = row.insertCell(-1);
      cell.append(canvas);
    }
  }
}

getContext(compositeIndex, testIndex) {
  var id = compositeTypes[compositeIndex] + testNames[testIndex];
  var context = getContext2d(id);
  return context;
}

setupContext(context, alpha) {
  if (alpha) {
    context.fillStyle = 'rgba(00,100,255,0.5)';
  } else {
    context.fillStyle = 'rgba(00,100,255,1)';
  }
  context.fillRect(5, 5, 120, 30);
  context.beginPath();
  context.moveTo(0, 0);
  context.lineTo(0, 45);
  context.lineTo(80, 45);
  context.lineTo(80, 0);
  context.clip();
  context.translate(40, -10);
  context.scale(0.4, 0.6);
  context.rotate(Math.pi / 8);
  context.translate(-10, -10);
}

addOutput(element, style, innerHtml) {
  var outputDiv = document.getElementById('output');
  var outputEl = document.createElement(element);
  if (style != null)
      outputEl.setAttribute('class', style);
  outputEl.innerHtml = innerHtml;
  outputDiv.append(outputEl);
}

addExpectedOutput(context, x, y, actualColor, addBreak, addOpening, addClosing) {
  var errorString = '[' + actualColor[0].join(',') + ']';
  if (addOpening)
    errorString = '[' + errorString;
  if (addClosing)
    errorString = errorString + ']';
  errorString = errorString + ', ';
  if (addBreak)
    errorString = errorString + '<br>';
  addOutput('span', '', errorString);
}

rebaseline(context, compositeIndex, testIndex) {
  for (var i = 0; i < testPoints.length; i++) {
    var img = context.getImageData(testPoints[i]['x'], testPoints[i]['y'], 1, 1).data;
    var actualColor = [img[0], img[1], img[2], img[3]];
    addExpectedOutput(context, testPoints[i]['x'], testPoints[i]['y'], actualColor, ((i+1)%6) != 0, i == 0, i == 23);
  }
}

isDifferentColor(actualColor, expectedColor) {
    var actualAlpha = actualColor[3];
    var expectedAlpha = expectedColor[3];
    if (abs(actualAlpha - expectedAlpha) > 3) return true;
    // For the value of RGB, we compare the values the users actually see.
    if (abs(actualColor[0] * actualAlpha / 256 - expectedColor[0] * expectedAlpha / 256) > 3) return true;
    if (abs(actualColor[1] * actualAlpha / 256 - expectedColor[1] * expectedAlpha / 256) > 3) return true;
    if (abs(actualColor[2] * actualAlpha / 256 - expectedColor[2] * expectedAlpha / 256) > 3) return true;
    return false;
}

addError(context, x, y, actualColor, expectedColor) {
  context.fillStyle = 'rgb(255, 0, 0)';
  context.fillRect(x, y, 1, 1);
  var errorString = 'Error at ($x, $y): ';
  errorString = errorString + 'Actual color [' + actualColor.join(',') + ']; ';
  errorString = errorString + 'Expected color [' + expectedColor.join(',') + ']; ';
  addOutput('div', 'error', errorString);
}

checkResult(context, compositeIndex, testIndex) {
  var errorCount = 0;
  for (var i = 0; i < testPoints.length; i++) {
    var img = context.getImageData(testPoints[i]['x'], testPoints[i]['y'], 1, 1).data;
    var actualColor = [img[0], img[1], img[2], img[3]];
    var expectedColor = expectedColors[compositeIndex][testIndex][i];
    if (isDifferentColor(actualColor, expectedColor)) {
      addError(context, testPoints[i]['x'], testPoints[i]['y'], actualColor, expectedColor);
      errorCount++;
    }
  }
  if (errorCount > 0) {
    var msg = 'FAIL: $errorCount errors.';
    addOutput('div', 'fail', msg);
    testFailed(msg);
  }
  else {
    //addOutput('div', 'pass', 'PASS');
  }
}

runTest(setupTest, drawImage) {
  setupTest();
  createOutputTable();
  for (var i = 0; i < compositeTypes.length; i++) {
    for (var j = 0; j < testNames.length; j++) {
      var context = getContext(i, j);
      context.save();
      setupContext(context, j % 4 > 1);
      drawImage(context, i, j % 2 != 0);
      context.restore();
    }
  }
  for (var i = 0; i < compositeTypes.length; i++) {
    addOutput('h1', '', 'Mode: ' + compositeTypes[i]);
    for (var j = 0; j < testNames.length; j++) {
      addOutput('h2', '', 'Test: ' + testNames[j]);
      var context = getContext(i, j);
      checkResult(context, i, j);
      //rebaseline(context, i, j);
    }
  }
}
