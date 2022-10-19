import 'package:resto_app/data/models/customer_review_model.dart';

class Review {
  Review({
    required this.error,
    required this.message,
    required this.customerReviews,
  });

  final bool error;
  final String message;
  final List<CustomerReviewModel> customerReviews;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        error: json["error"],
        message: json["message"],
        customerReviews: List<CustomerReviewModel>.from(json["customerReviews"]
            .map((x) => CustomerReviewModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "customerReviews":
            List<dynamic>.from(customerReviews.map((x) => x.toJson())),
      };
}
