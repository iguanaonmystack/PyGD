from libc.stdlib cimport calloc, free
from libc.stdio cimport printf, fdopen, fclose, FILE

cdef extern from "gd.h":
    ctypedef struct gdImage
    ctypedef struct gdPoint:
        int x
        int y
    cdef gdImage * gdImageCreate(int sx, int sy)
    cdef void gdImageDestroy(gdImage * im)
    cdef int gdImageColorAllocate (gdImage * im, int r, int g, int b);
    cdef void gdImageFilledPolygon(gdImage * im, gdPoint * p, int n, int c)
    cdef void gdImagePng(gdImage * im, FILE * out)


cdef class Image:
    cdef gdImage * cobj
    cdef dict colormap

    def __cinit__(self, int size_x, int size_y, bgcolor=(255, 255, 255)):
        cdef gdImage * image
        image = gdImageCreate(size_x, size_y)
        if image is NULL:
            raise Exception('Unable to create gdImage')
        self.cobj = image
        self.colormap = {}
        self._color_to_gdcolor(bgcolor)
    
    def __dealloc__(self):
        if self.cobj:
            gdImageDestroy(self.cobj)
            self.cobj = NULL

    cdef int _color_to_gdcolor(self, color):
        '''GD works by assigning an integer to each colour used in the image.
        Each image gets a different mapping based on the order of assignment.

        color -- a python three-tuple with r,g,b values 0 <= val <= 255

        Returns the colour mapping value to be used in gdImage calls.
        '''
        cdef int gdcolor
        if color in self.colormap:
            gdcolor = self.colormap[color]
        else:
            gdcolor = gdImageColorAllocate(self.cobj,
                                           color[0], color[1], color[2])
            self.colormap[color] = gdcolor
        return gdcolor

    def filled_polygon(self, *points, color=(0, 0, 0)):
        cdef size_t i
        cdef int gdcolor
        cdef size_t points_len = len(points)
        cdef gdPoint * c_points

        c_points = <gdPoint *>calloc(points_len, sizeof(gdPoint))
        if c_points is NULL:
            raise MemoryError('Out of memory for points')
        try:
            for i in range(points_len):
                c_points[i].x = points[i][0]
                c_points[i].y = points[i][1]
            gdcolor = self._color_to_gdcolor(color)
            gdImageFilledPolygon(self.cobj, c_points, points_len, gdcolor)
        finally:
            free(c_points)

    def dump(self, fp, format='png'):
        cdef int fd
        cdef FILE * out
        if format != 'png':
            raise ValueError('Just png for now') # TODO
        try:
            fd = fp.fileno()
        except (AttributeError, TypeError):
            raise TypeError(
                'fp must be a file-like object with a fileno() method')
        out = fdopen(fd, 'wb')
        if out is NULL:
            raise Exception("Unable to open fp %d as 'wb'" % fd)
        gdImagePng(self.cobj, out)
        fclose(out)
    
