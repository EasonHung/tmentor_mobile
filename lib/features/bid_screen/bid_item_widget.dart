import 'package:flutter/material.dart';
import 'package:mentor_app_flutter/features/introduce_screen/introduce_screen.dart';
import 'package:mentor_app_flutter/vo/bid_info_item.dart';

class BidInfoItemWidget extends StatelessWidget {
  final BidInfoItem bidInfoItem;

  BidInfoItemWidget(this.bidInfoItem);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context){
          return IntroduceScreen(bidInfoItem.bidderId, true);
        }));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Card(
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0)
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20))
            ),
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(bidInfoItem.bidderAvatorUrl)
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(bidInfoItem.bidderNickname, style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold)),
                    Text("job: " + bidInfoItem.bidderJob, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal)),
                    Text("school: " + bidInfoItem.bidderEducation, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal)),
                    Text("gender: " + bidInfoItem.bidderGender, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal)),
                  ],
                ),
                Text("prize: " + bidInfoItem.bidPrice.toString() + "/hr", style: TextStyle(color: Colors.grey, fontSize: 18.0, fontWeight: FontWeight.bold)),
              ],
            )
          ),
        ),
      )
    );
  }
  
}