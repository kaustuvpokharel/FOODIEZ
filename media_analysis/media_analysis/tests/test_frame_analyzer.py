from media_analysis.models.frame_analyzer import FrameAnalyzer


fries = "https://www.inspiredtaste.net/wp-content/uploads/2022/10/Baked-French-Fries-Recipe-1200.jpg"
cheese_cake = "https://www.onceuponachef.com/images/2017/12/cheesecake-1200x1393.jpg"
choc_cake = "https://thescranline.com/wp-content/uploads/2024/10/CHOCOLATE-FUDGE-CAKE-24-S-11.jpg"
burger = "https://assets.epicurious.com/photos/5c745a108918ee7ab68daf79/1:1/w_2560%2Cc_limit/Smashburger-recipe-120219.jpg"
pizza = "https://hips.hearstapps.com/hmg-prod/images/classic-cheese-pizza-recipe-2-64429a0cb408b.jpg"
salad = "https://cdn.loveandlemons.com/wp-content/uploads/2024/12/caesar-salad.jpg"
spaghetti = "https://leitesculinaria.com/wp-content/uploads/2024/04/spaghetti-carbonara-1200.jpg"

analyzer = FrameAnalyzer()

# Test for French fries
def test_fries():
    assert analyzer.make_prediction(fries) == "french_fries"

# Test for Cheesecake
def test_cheesecake():
    assert analyzer.make_prediction(cheese_cake) == "cheesecake"

# Test for Chocolate Cake
def test_chocolate_cake():
    assert analyzer.make_prediction(choc_cake) == "chocolate_cake"

# Test for Burger
def test_burger():
    assert analyzer.make_prediction(burger) == "hamburger"

# Test for Pizza
def test_pizza():
    assert analyzer.make_prediction(pizza) == "pizza"

# Test for Salad
def test_salad():
    assert analyzer.make_prediction(salad) == "caesar_salad"

# Test for Spaghetti
def test_spaghetti():
    assert analyzer.make_prediction(spaghetti) == "spaghetti_carbonara"
