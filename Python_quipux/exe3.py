
# Me base en el tutorial: 
# https://pyimagesearch.com/2020/09/21/opencv-automatic-license-number-plate-recognition-anpr-with-python/

import cv2
import numpy as np
import imutils


def show_image(title, image, wait_keypress=False):

    cv2.imshow(title, image)

    if wait_keypress:
        cv2.waitKey(0)


def plate(gray, candidates):

    plate_contour = None
    roi = None

    # loop over the license plate candidate contours
    for candidate in candidates:

        # bounding box of the contour to derive the aspect ratio
        (x, y, w, h) = cv2.boundingRect(candidate)

        aspect_ratio = w / float(h)
        if aspect_ratio >= minimum_aspect_ratio and aspect_ratio <= maximum_aspect_ratio:
            plate_contour = candidate
            plate = gray[y:y + h, x:x + w]
            roi = cv2.threshold(plate, 0, 255,
                                cv2.THRESH_BINARY_INV | cv2.THRESH_OTSU)[1]

            # it shows the plate image
            show_image("License Plate", plate, wait_keypress=False)
            show_image("ROI", roi, wait_keypress=True)


def find_candidates(gray, n_contours=5):

    # it finds black characters in light backgrounds
    structuring_element = cv2.getStructuringElement(cv2.MORPH_RECT, (13, 5))
    blackhat = cv2.morphologyEx(gray, cv2.MORPH_BLACKHAT, structuring_element)
    show_image("1: Blackhat", blackhat)

    # it finds light regions that could be a plate
    square_kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (3, 3))
    # it do a binary threshold on image applying Otsu’s method
    light_image = cv2.morphologyEx(gray, cv2.MORPH_CLOSE, square_kernel)
    light_image = cv2.threshold(light_image, 0, 255,
                          cv2.THRESH_BINARY | cv2.THRESH_OTSU)[1]
    show_image("2: Light Regions", light_image)

    # Scharr gradient detect edges in the image in the x-direction
    gradient_Scharr = cv2.Sobel(blackhat, ddepth=cv2.CV_32F, dx=1, dy=0, ksize=-1)
    gradient_Scharr = np.absolute(gradient_Scharr)
    min_val, max_val = (np.min(gradient_Scharr), np.max(gradient_Scharr))
    # scale the result back to the range (0, 255)
    gradient_Scharr = 255 * ((gradient_Scharr - min_val) / (max_val - min_val))
    gradient_Scharr = gradient_Scharr.astype("uint8")
    show_image("3: Scharr gradient", gradient_Scharr)

    # it applies blur on gradient representation
    gradX = cv2.GaussianBlur(gradient_Scharr, (5, 5), 0)
    gradX = cv2.morphologyEx(gradX, cv2.MORPH_CLOSE, structuring_element)
    # binary threshold using Otsu’s method
    threshold = cv2.threshold(gradX, 0, 255, cv2.THRESH_BINARY | cv2.THRESH_OTSU)[1]
    show_image("4: Threshold", threshold)

    # erosion and dilation to clean up the image
    threshold = cv2.erode(threshold, None, iterations=3)
    threshold = cv2.dilate(threshold, None, iterations=3)
    show_image("5: Erode and Dilate", threshold)

    # The light image is used as mask for a bitwise-AND between
    # the thresholded image and the light regions
    # it reveals the plate candidates
    threshold = cv2.bitwise_and(threshold, threshold, mask=light_image)
    threshold = cv2.dilate(threshold, None, iterations=2)
    threshold = cv2.erode(threshold, None, iterations=1)
    show_image("6: After processing", threshold, wait_keypress=False)

    # it finds contours in the thresholded image
    contours = cv2.findContours(threshold, cv2.RETR_EXTERNAL,cv2.CHAIN_APPROX_SIMPLE)
    contours = imutils.grab_contours(contours)
    # sort contours by size to get the largest ones
    contours = sorted(contours, key=cv2.contourArea, reverse=True)[:n_contours]
    # return the list of contours
    return contours


def find_plate(image, clearBorder=False):
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    candidates = find_candidates(gray)
    plate(gray, candidates)


images = ['car-15.png']
clear_border = 1
minimum_aspect_ratio = 1
maximum_aspect_ratio = 15

for image_path in images:

    # load the input image
    image = cv2.imread(image_path)
    # resize the input image
    image = imutils.resize(image, width=600)

    # plate recognition
    find_plate(image)