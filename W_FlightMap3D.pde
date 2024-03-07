import java.util.function.Function;
import java.util.function.Consumer;

class FlightMap3D extends Widget implements IDraggable {

  private Event<MouseDraggedEventInfoType> m_onDraggedEvent = new Event<MouseDraggedEventInfoType>();

  private PShape m_earthModel;
  private PImage m_earthTex;
  private PImage m_earthNormalMap;
  private PShader m_earthShader;

  private PVector m_earthRotation = new PVector(0, 0, 0);
  private PVector m_earthRotationalVelocity = new PVector(0, 0, 0);
  private final float m_earthRotationalFriction = 0.99;

  private boolean m_ready = false;

  private PImage m_backgroundImg;

  public FlightMap3D() {
    super(0, 0, width, height);

    new Thread(() -> {
      m_earthModel = s_3D.createShape(SPHERE, 200);
      m_earthModel.disableStyle();

      m_earthTex = loadImage("data/Images/EarthDay2k.jpg");
      m_earthNormalMap = loadImage("data/Images/EarthNormal2k.tif");

      m_earthShader = loadShader("data/Shaders/EarthFrag.glsl", "data/Shaders/EarthVert.glsl");

      m_earthShader.set("tex", m_earthTex);
      m_earthShader.set("normalMap", m_earthNormalMap);

      m_ready = true;
      println("3D READY!");
    }
    ).start();

    m_backgroundImg = loadImage("data/Images/Stars2k.jpg");
    m_onDraggedEvent.addHandler(e -> onDraggedHandler(e));
  }

  @ Override
    public void draw() {
    super.draw();

    m_earthRotationalVelocity.x %= 2 * PI;
    m_earthRotationalVelocity.y %= 2 * PI;
    
    m_earthRotation.add(m_earthRotationalVelocity);
    m_earthRotationalVelocity.mult(m_earthRotationalFriction);

    image(m_backgroundImg, 0, 0, width, height);

    if (!m_ready) {
      textAlign(CENTER);
      text("Loading...", width/2, height/2);
      return;
    }

    s_3D.beginDraw();
    s_3D.pushMatrix();

    s_3D.clear();
    s_3D.noStroke();

    s_3D.shader(m_earthShader);

    s_3D.translate(width/2, height/2, -20);
    s_3D.rotateY(m_earthRotation.y);
    s_3D.rotateX(m_earthRotation.x);
    s_3D.shape(m_earthModel);

    s_3D.resetShader();

    s_3D.popMatrix();
    s_3D.endDraw();

    image(s_3D, 0, 0);
  }

  public Event<MouseDraggedEventInfoType> getOnDraggedEvent() {
    return m_onDraggedEvent;
  }

  private void onDraggedHandler(MouseDraggedEventInfoType e) {
    PVector deltaDrag = new PVector( -(e.Y - e.PreviousPos.y), e.X - e.PreviousPos.x);
    deltaDrag.mult(s_deltaTime).mult(0.000003f);
    m_earthRotationalVelocity.add(deltaDrag);
  }
}
