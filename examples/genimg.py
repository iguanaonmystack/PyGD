import argparse

import pygd

poly = [(43, 45), (43, 29), (49, 22), (89, 22), (97, 30), (97, 65), (89, 74),
        (50, 76), (40, 87), (40, 104), (24, 104), (14, 82), (14, 68), (24, 50),
        (70, 50), (70, 45)]

_p = (71, 77)  # reflection point
poly2= [(2*_p[0] - a[0], 2*_p[1] - a[1]) for a in poly]

dot1 = [(52, 29), (52, 35), (58, 35), (58, 29)]
dot2 = [(2*_p[0] - a[0], 2*_p[1] - a[1]) for a in dot1]

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Generate an example image')
    parser.add_argument('filename')
    args = parser.parse_args()

    img = pygd.Image(150, 150, bgcolor=(40, 65, 90))
    img.filled_polygon(*poly, color=(70, 135, 185))
    img.filled_polygon(*poly2, color=(255, 215, 65))
    img.filled_polygon(*dot1, color=(255, 255, 255))
    img.filled_polygon(*dot2, color=(255, 255, 255))
    
    f = open(args.filename, 'wb')
    img.dump(f)
