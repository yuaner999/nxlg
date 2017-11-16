/**
 * Created by NEU on 2017/9/8.
 */
public class FactoryPatternDemo {
    public static void main(String[] args){
//        ShapeFactory shapeFactory = new ShapeFactory();
//
//        Shape shape1 = shapeFactory.getShape("CIRCLE");
//
//        shape1.draw();

        Rectangle rect = (Rectangle) ShapeFactory.getClass(Rectangle.class);
        rect.draw();
    }
}
