import 'package:flutter/material.dart';
import '../models/producto.dart';
import 'agregar_producto.dart';
import 'editar_producto.dart';

class ListaProductosPage extends StatefulWidget {
  const ListaProductosPage({super.key});

  @override
  State<ListaProductosPage> createState() => _ListaProductosPageState();
}

class _ListaProductosPageState extends State<ListaProductosPage> {
  // Lista de productos de prueba
  List<Producto> productos = [
    Producto(
      id: 1,
      nombre: 'Auriculares Bluetooth',
      descripcion: 'Auriculares inalámbricos con cancelación de ruido',
      categoria: 'Electrónica',
      proveedor: 'SoundMax',
      codigoBarras: '100200300',
      precio: 49.99,
      stock: 25,
    ),
    Producto(
      id: 2,
      nombre: 'Laptop HP 14"',
      descripcion: 'Laptop HP con 8GB RAM y 512GB SSD',
      categoria: 'Computadoras',
      proveedor: 'HP Inc.',
      codigoBarras: '300400500',
      precio: 2599.00,
      stock: 10,
    ),
  ];

  void _editarProducto(Producto producto, int index) async {
    final Producto? productoEditado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditarProductoPage(producto: producto),
      ),
    );

    if (productoEditado != null) {
      setState(() {
        productos[index] = productoEditado;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Producto actualizado ✅')),
      );
    }
  }

  void _eliminarProducto(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar producto'),
        content: const Text('¿Estás seguro de eliminar este producto?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                productos.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Producto eliminado 🗑️')),
              );
            },
            child: const Text(
              'Eliminar',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductoCard(Producto p, int index) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey.shade800, Colors.blueGrey.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nombre y botones
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      p.nombre,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.white70),
                        onPressed: () => _editarProducto(p, index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => _eliminarProducto(index),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Descripción
              Text(
                p.descripcion,
                style: const TextStyle(color: Colors.white70),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 8),

              // Info adicional en fila
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _infoChip(Icons.category, p.categoria),
                  _infoChip(Icons.qr_code, p.codigoBarras),
                ],
              ),

              const SizedBox(height: 10),

              // Precio y stock
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'S/ ${p.precio.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.lightGreenAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Stock: ${p.stock}',
                    style: TextStyle(
                      color: p.stock > 10 ? Colors.white : Colors.amberAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.white70),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('📦 Inventario de Productos'),
        backgroundColor: Colors.blueGrey.shade800,
      ),
      body: productos.isEmpty
          ? const Center(
              child: Text(
                'No hay productos aún',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: productos.length,
              itemBuilder: (context, index) {
                final p = productos[index];
                return _buildProductoCard(p, index);
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey.shade700,
        onPressed: () async {
          final Producto? nuevo = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AgregarProductoPage()),
          );
          if (nuevo != null) {
            setState(() => productos.add(nuevo));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Producto agregado ✅')),
            );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}