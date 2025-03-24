from media_analysis.models.frame_analyzer import FrameAnalyzer


fries = "https://www.inspiredtaste.net/wp-content/uploads/2022/10/Baked-French-Fries-Recipe-1200.jpg"
cheese_cake = "https://www.onceuponachef.com/images/2017/12/cheesecake-1200x1393.jpg"
choc_cake = "https://thescranline.com/wp-content/uploads/2024/10/CHOCOLATE-FUDGE-CAKE-24-S-11.jpg"

analyzer = FrameAnalyzer()

def test_fries():
    assert analyzer.make_prediction(fries) == "french_fries"

def test_cheesecake():
    assert analyzer.make_prediction(cheese_cake) == "cheesecake"

def test_chocolate_cake():
    assert analyzer.make_prediction(choc_cake) == "chocolate_cake"