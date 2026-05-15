import 'package:apartment_rentals/models/static/property_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PropertyService {
  final _client = Supabase.instance.client;

  /// Queries the [properties] table with optional full-text search across
  /// title/city and slider-based price + bedroom filters.
  Future<List<PropertyModel>> searchProperties({
    String query = '',
    double minPrice = 500,
    double maxPrice = 5000,
    int? bedrooms,
  }) async {
    var req = _client
        .from('properties')
        .select()
        .gte('price', minPrice)
        .lte('price', maxPrice);

    if (query.isNotEmpty) {
      req = req.or('title.ilike.%$query%,city.ilike.%$query%');
    }
    if (bedrooms != null) {
      req = bedrooms >= 4
          ? req.gte('bedrooms', 4)
          : req.eq('bedrooms', bedrooms);
    }

    final data = await req.order('created_at', ascending: false);
    return (data as List)
        .map((e) => PropertyModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
