import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../colors.dart';
import 'ViewNotification.dart';

class Home extends StatefulWidget {
  final String userID;
  final VoidCallback onSeeAllClicked;

  const Home({Key? key, required this.onSeeAllClicked, required this.userID}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final imageUrls = [
      "assets/images/cleaning1.jpg",
      "assets/images/11.jpg",
      "assets/images/1.jpg"
    ];
    final details = ['Cleaning', 'Electric Works', 'Bathroom Cleaning'];
    final prices = ['499', '299', '399'];
    final List<Map<String, String>> offers = [
      {
        'imagePath': "assets/images/2.jpg",
        'offerText': '50% Off on First Service',
      },
      {
        'imagePath': "assets/images/3.jpg",
        'offerText': 'Buy One Get One Free',
      },
      {
        'imagePath': "assets/images/4.jpg",
        'offerText': 'Free Consultation with Every Service',
      },
      {
        'imagePath':"assets/images/5.jpg",
        'offerText': '20% Off for New Home',
      },
    ];

    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.c1,
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: IconButton(onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ViewNotification(userID: widget.userID,)));
            }, icon:Icon(Icons.notifications), color: Colors.amber),
          )
        ],
        title: Row(
          children: [
            Image.asset("assets/images/sn.png", scale: 10,),
            Text("SERVICE NEST",style: TextStyle(
                fontFamily: 'Lato',fontSize: width * 0.07, color: AppColors.c4, fontWeight: FontWeight.bold
            ),),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  autoPlay: true,
                  height: height * 0.2,
                  enlargeCenterPage: true,
                  aspectRatio: 16 / 9,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  viewportFraction: 0.8,
                ),
                items: offers.map((offer) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: AssetImage(offer['imagePath']!),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              bottom: 10,
                              left: 10,
                              right: 10,
                              child: Container(
                                color: Colors.black45,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    offer['offerText']!,
                                    style: TextStyle(
                                      fontSize: width * 0.04,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Categories",
                    style: TextStyle(
                      fontSize: width * 0.05,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Lato-Regular',
                    ),
                    textAlign: TextAlign.left,
                  ),
                  TextButton(
                    onPressed: widget.onSeeAllClicked,
                    child: Text(
                      "See all",
                      style: TextStyle(
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: height * 0.01),
              Container(
                height: height * 0.3,
                child: GridView.count(
                  crossAxisCount: (width > 600) ? 6 : 4, // Adjust for desired number of columns based on screen width
                  mainAxisSpacing: 5.0,
                  crossAxisSpacing: 20.0,
                  childAspectRatio: 0.7,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    CategoryItem(
                      imageUrl: 'assets/images/c1.png',
                      categoryName: 'Carpenter',
                    ),
                    CategoryItem(
                      imageUrl: 'assets/images/cl.jpg',
                      categoryName: 'Cleaning',
                    ),
                    CategoryItem(
                      imageUrl: 'assets/images/paint-roller.png',
                      categoryName: 'Painting',
                    ),
                    CategoryItem(
                      imageUrl: 'assets/images/E.png',
                      categoryName: 'Electrician',
                    ),
                    CategoryItem(
                      imageUrl: 'assets/images/ac.png',
                      categoryName: 'AC Repair',
                    ),
                    CategoryItem(
                      imageUrl: 'assets/images/plumber.jpg',
                      categoryName: 'Plumber',
                    ),
                    CategoryItem(
                      imageUrl: 'assets/images/gardening.png',
                      categoryName: 'Gardening',
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.02),
              Text(
                "Popular on Service Nest",
                style: TextStyle(
                  fontSize: width * 0.05,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: height * 0.01),
              Container(
                height: height * 0.4,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: imageUrls.length, // Number of items
                  itemBuilder: (context, index) {
                    return CustomItemWidget(
                      imageUrl: imageUrls[index],
                      rating: 4.5,
                      details: details[index],
                      price: prices[index],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomItemWidget extends StatelessWidget {
  final String imageUrl;
  final double rating;
  final String details;
  final String price;

  const CustomItemWidget({
    required this.imageUrl,
    required this.rating,
    required this.details,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;

    return Container(
      width: width * 0.5, // Adjust width based on screen size
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.asset(
              imageUrl,
              height: height * 0.2,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Icon(Icons.star, color: Colors.amber),
              Icon(Icons.star, color: Colors.amber),
              Icon(Icons.star, color: Colors.amber),
              Icon(Icons.star, color: Colors.amber),
              Icon(Icons.star, color: Colors.amber),
            ],
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  details,
                  style: TextStyle(
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String imageUrl;
  final String categoryName;

  const CategoryItem({
    required this.imageUrl,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: Image.asset(
            imageUrl,
            fit: BoxFit.contain,
          ),
        ),
        Positioned(
          bottom: 10.0,
          left: 10.0,
          child: Text(
            categoryName,
            style: TextStyle(
              color: Colors.black,
              fontSize: width * 0.04,
              fontWeight: FontWeight.bold,
              fontFamily: 'Lato',
              shadows: [
                Shadow(
                  blurRadius: 6.0,
                  color: Colors.black.withOpacity(0.5),
                  offset: Offset(1.0, 1.0),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
