class B extends A implements I {
    int b = 0;
    int c = 0;

    void m() {
        int b = 1;
        int c = 1;
        
        b=2;
        if (hello == 1) {
            b=3;
            c=2;
        }
        else {
            b=4;
            a=3;
        }

        yolo(a, b, c);

        return 0;
    }
}