/**
 * F. Wright
 *
 * Screen representing the home screen of the application.
 */
class ScreenHome extends Screen {
  ImageUI m_earthImage;
  ImageUI m_starImage;
  ImageUI m_starImageWrap;
  int m_earthBasePosY;

  /**
   * F. Wright
   *
   * Constructs a new instance of ScreenHome with the given screen ID.
   *
   * @param screenId The unique identifier for the screen.
   */
  public ScreenHome(String screenId) {
    super(screenId, DEFAULT_SCREEN_COLOUR);
  }

  /**
   * F. Wright
   *
   * Initializes the screen by adding UI elements and setting their properties.
   */
  @Override
    public void init() {
    super.init();
    m_starImage = new ImageUI("data/Images/Stars2k.jpg", 0, 0, width, height);
    m_starImageWrap = new ImageUI("data/Images/Stars2k.jpg", -width, 0, width, height);

    addWidget(m_starImage);
    addWidget(m_starImageWrap);

    float growScale = 1.05f;
    float totalSpacing = (float)height/4.0;
    float totalButtonSize = height-totalSpacing;
    float oneSpacingUnit = totalSpacing/4.0;
    float oneButtonUnit = totalButtonSize/3.0;

    String earthImagePath = "data/Images/earthTitleScreenTrans.png";
    int earthScale = 800;
    int earthPosX = int((width * 0.4f) - (earthScale * 0.5f));
    m_earthBasePosY = int(height * 0.2f);
    m_earthImage = new ImageUI(earthImagePath, earthPosX, m_earthBasePosY, earthScale, earthScale);
    addWidget(m_earthImage);

    ButtonUI switchTo3D = createButton((int)width-(width/4), (int)((oneSpacingUnit*2)+oneButtonUnit), (int)width/4 - 100, (int)oneButtonUnit);
    switchTo3D.setBackgroundColour(COLOR_BLACK);
    switchTo3D.setOutlineColour(COLOR_WHITE);
    switchTo3D.getOnClickEvent().addHandler(e -> switchScreen(e, SCREEN_ID_3DFM));
    switchTo3D.setText("3D Globe");
    switchTo3D.setTextSize((int)((float)height/20.0));
    switchTo3D.setGrowScale(growScale);

    ButtonUI switchToCharts = createButton((int)width-(width/4), (int)((oneSpacingUnit*3)+(oneButtonUnit*2)), (int)width/4 - 100, (int)oneButtonUnit);
    switchToCharts.setBackgroundColour(COLOR_BLACK);
    switchToCharts.setOutlineColour(COLOR_WHITE);
    switchToCharts.getOnClickEvent().addHandler(e -> switchScreen(e, SCREEN_ID_CHARTS));
    switchToCharts.setText("Charts");
    switchToCharts.setTextSize((int)((float)height/20.0));

    LabelUI title = createLabel((int)oneSpacingUnit, (int)oneSpacingUnit, (int)((float)width/2.0), (int)((float)height/5.0), "High5ive");
    title.setCentreAligned(false);
    title.setTextSize((int)((float)height/10.0));

    LabelUI subTitle = createLabel((int)(oneSpacingUnit*1.1), (int)((float)height/4.0), (int)((float)width/2.0), (int)((float)height/10.0), "Flights :)");
    subTitle.setForegroundColour(COLOR_LIGHT_GRAY);
    subTitle.setCentreAligned(false);
    subTitle.setTextSize((int)((float)height/20.0));

    switchToCharts.setGrowScale(growScale);
  }

  /**
   * T. Creagh
   *
   * Changes the positions of the earth and stars over time
   */
  @Override
    public void draw() {
    super.draw();
    float earthPosX = m_earthImage.getPos().x;
    float earthPosY = m_earthBasePosY + 10 * sin(millis() * 0.001);
    m_earthImage.setPos(earthPosX, earthPosY);

    float newPosX = (m_starImage.getPos().x + s_deltaTime * 0.1f) % width;
    m_starImage.setPos(newPosX, 0);
    m_starImageWrap.setPos(newPosX - width, 0);
  }
}

// Descending code authorship changes:
// A. Robertson, Wrote Screen1 and Screen2 presets
// F. Wright, Modified and simplified code to fit coding standard. Fixed checkbox issues with colours, 6pm 04/03/24
// F. Wright, Refactored screen, presets and applied grow mode to relevant widgets, 1pm 07/03/24
// F. Wright, Created 3D flight map screen using OpenGL GLSL shaders and P3D features. Implemented light shading and day-night cycle, 9pm 07/03/24
// M. Orlowski, Worked on 2D Map Button, 1pm 12/03/2024
// CKM, reintroduced some code that was overwritten, 14:00 12/03
// CKM, implemented spin control for 3D map, 10:00 13/03
// M. Orlowski, Added 2D calls, 12:00 13/03
// M. Poole added TextBoxes and removed background 5pm 13/03
// F.Wright Split HomeScreen into new File 26/03
// CKM, fixed reversion issue, 17:00 28/03
