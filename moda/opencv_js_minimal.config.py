# Minimal OpenCV.js configuration for moda-studio
# Only includes modules needed for watermark removal and contour detection
# Based on official opencv_js.config.py format

# Core module - basic data structures
core = {
    '': [
        # Basic types
        'Mat',
        'MatVector',
        'Size',
        'Point',
        'Scalar',
        'Rect',
        'Range',
        # Basic operations
        'LUT',
        'minMaxLoc',
        'flip',
        'split',
        'merge',
        'copyMakeBorder',
        'bitwise_and',
        'bitwise_or',
        'bitwise_not',
    ],
    'Algorithm': [],
    'Mat': ['eye', 'zeros', 'ones'],
}

# Image processing module - contour detection, color conversion
imgproc = {
    '': [
        # Contour functions (used in dxfAnalysis.ts)
        'approxPolyDP',
        'contourArea',
        'findContours',
        # Color conversion
        'cvtColor',
        # Thresholding
        'threshold',
        # Image I/O for canvas
        'imread',
        # Other useful functions
        'Canny',
        'dilate',
        'erode',
        'GaussianBlur',
        'getStructuringElement',
        'morphologyEx',
    ],
}

# Photo module - inpainting for watermark removal
photo = {
    '': [
        'inpaint',
    ],
}

# Image codecs - encode/decode images
imgcodecs = {
    '': [
        'imdecode',
        'imencode',
    ],
}

def makeWhiteList(module_list):
    wl = {}
    for m in module_list:
        for k, v in m.items():
            if k in wl:
                wl[k] += v
            else:
                wl[k] = v
    return wl

white_list = makeWhiteList([core, imgproc, photo, imgcodecs])

