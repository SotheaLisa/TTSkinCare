
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'dark_logic.dart';
import 'product_detail_screen.dart';
import '../model/product_model.dart';
import '../service/skincare_service.dart';

class SearchSkincareScreen extends StatefulWidget {
  const SearchSkincareScreen({super.key});

  @override
  State<SearchSkincareScreen> createState() => _SearchSkincareScreenState();
}

class _SearchSkincareScreenState extends State<SearchSkincareScreen> {
  final _scroller = ScrollController();
  final _searchCtrl = TextEditingController();
  bool _showFab = false;

  final _service = SkincareService();
  late Future<List<SkincareProduct>> _futureData =
      _service.search(_searchCtrl.text.trim());

  @override
  void initState() {
    super.initState();
    _scroller.addListener(() {
      final show = _scroller.position.pixels > 500;
      if (show != _showFab) setState(() => _showFab = show);
    });
  }

  @override
  void dispose() {
    _scroller.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = context.watch<LayoutConfigLogic>();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchCtrl,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: 'Search brand, type, category…',
            border: InputBorder.none,
          ),
          onSubmitted: (text) {
            setState(() {
              _futureData = _service.search(text.trim());
            });
          },
        ),
        actions: [
          if (_searchCtrl.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchCtrl.clear();
                setState(() => _futureData =
                    _service.search(''));
              },
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => setState(() {
          _futureData = _service.search(_searchCtrl.text.trim());
        }),
        child: FutureBuilder<List<SkincareProduct>>(
          future: _futureData,
          builder: (context, snapshot) {
            if (snapshot.hasError) return _buildError(snapshot.error.toString());
            if (snapshot.connectionState == ConnectionState.done) {
              return _buildResults(snapshot.data!, config);
            }
            return _buildSkeleton();
          },
        ),
      ),
      floatingActionButton: _showFab
          ? FloatingActionButton(
              shape: const CircleBorder(),
              onPressed: () => _scroller.animateTo(0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut),
              child: const Icon(Icons.arrow_upward),
            )
          : null,
    );
  }

  Widget _buildResults(List<SkincareProduct> items, LayoutConfigLogic config) {
    if (_searchCtrl.text.trim().isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text('Search for skincare products',
                style: TextStyle(color: Colors.grey.shade400)),
          ],
        ),
      );
    }
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text('No results for "${_searchCtrl.text}"',
                style: TextStyle(color: Colors.grey.shade400)),
          ],
        ),
      );
    }

    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final w = MediaQuery.of(context).size.width;

    return GridView.builder(
      controller: _scroller,
      padding: EdgeInsets.symmetric(
          horizontal: w > 1200 ? (w - 1200) / 2 : 8, vertical: 8),
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: config.isGridStyle ? (isLandscape ? 4 : 2) : 1,
        childAspectRatio: config.isGridStyle ? 2 / 3 : 5 / 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) => _buildCard(items[i]),
    );
  }

  Widget _buildCard(SkincareProduct item) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ProductDetailScreen(item)),
      ),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: item.images[0],
                    fit: BoxFit.cover,
                    placeholder: (_, __) =>
                        Container(color: Colors.grey.shade200),
                    errorWidget: (_, __, ___) =>
                        Container(color: Colors.grey.shade300),
                  ),
                  if (item.hasDiscount)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.pinkAccent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text('-${item.discountPercent}%',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 8, 0),
              child: Text(item.brand,
                  style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
              child: Row(
                children: [
                  Text('\$${item.discountPrice}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary)),
                  if (item.hasDiscount) ...[
                    const SizedBox(width: 4),
                    Text('\$${item.price}',
                        style: const TextStyle(
                            fontSize: 11,
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey)),
                  ],
                  const Spacer(),
                  Icon(Icons.star, size: 13, color: Colors.amber.shade600),
                  Text(' ${item.rating}',
                      style: const TextStyle(fontSize: 11)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeleton() {
    return Skeletonizer(
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: 6,
        itemBuilder: (_, __) => Card(
          child: ListTile(
            leading: Container(
                width: 56, height: 56, color: Colors.grey.shade200),
            title: Container(height: 14, color: Colors.grey.shade300),
            subtitle: Container(height: 12, color: Colors.grey.shade200),
          ),
        ),
      ),
    );
  }

  Widget _buildError(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 8),
          Text('Error: $error'),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () => setState(() =>
                _futureData = _service.search(_searchCtrl.text.trim())),
            icon: const Icon(Icons.refresh),
            label: const Text('RETRY'),
          ),
        ],
      ),
    );
  }
}