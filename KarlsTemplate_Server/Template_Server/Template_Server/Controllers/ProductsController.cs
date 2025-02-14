using Microsoft.AspNetCore.Mvc;

namespace RestServer.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ProductsController : ControllerBase
    {
        private static List<Product> Products = new()
        {
            new Product { Name = "Laptop", Price = 999.99, Description = "High-performance laptop with the latest processor and long battery life." },
            new Product { Name = "Smartphone", Price = 499.99, Description = "Feature-packed smartphone with an advanced camera and a stunning display." },
            new Product { Name = "Tablet", Price = 299.99, Description = "Lightweight tablet perfect for entertainment and productivity on the go." },
            new Product { Name = "Smartwatch", Price = 199.99, Description = "Stylish smartwatch with fitness tracking and smart notifications." },
            new Product { Name = "Wireless Headphones", Price = 149.99, Description = "Noise-canceling wireless headphones with immersive sound quality." },
            new Product { Name = "Mechanical Keyboard", Price = 89.99, Description = "Durable mechanical keyboard with customizable RGB lighting." },
            new Product { Name = "Gaming Mouse", Price = 59.99, Description = "High-precision gaming mouse with programmable buttons and ergonomic design." },
            new Product { Name = "Monitor 27-inch", Price = 249.99, Description = "Crystal-clear 27-inch monitor with high refresh rate and vivid colors." },
            new Product { Name = "External SSD 1TB", Price = 129.99, Description = "Ultra-fast 1TB external SSD for secure data storage and quick transfers." },
            new Product { Name = "USB-C Docking Station", Price = 79.99, Description = "Versatile USB-C docking station with multiple ports for enhanced connectivity." },
            new Product { Name = "Wireless Charger", Price = 39.99, Description = "Fast wireless charger compatible with most smartphones and accessories." },
            new Product { Name = "Portable Bluetooth Speaker", Price = 99.99, Description = "Compact Bluetooth speaker with powerful bass and long battery life." }
        };

        [HttpGet]
        public IActionResult GetProducts()
        {
            return Ok(Products);
        }

        [HttpGet("{id}")]
        public IActionResult GetProduct(string id)
        {
            var product = Products.FirstOrDefault(p => p.Id == id);
            if (product == null) return NotFound();
            return Ok(product);
        }

        [HttpPost]
        public IActionResult AddProduct([FromBody] Product product)
        {
            product.Id = Guid.NewGuid().ToString();
            Products.Add(product);
            Console.WriteLine(product.Name + " was added");
            return CreatedAtAction(nameof(GetProduct), new { id = product.Id }, product);
        }

        [HttpPut("{id}")]
        public IActionResult UpdateProduct(string id, [FromBody] Product updatedProduct)
        {
            var product = Products.FirstOrDefault(p => p.Id == id);
            if (product == null) return NotFound();

            product.Name = updatedProduct.Name;
            product.Price = updatedProduct.Price;
            return NoContent();
        }

        [HttpDelete("{id}")]
        public IActionResult DeleteProduct(string id)
        {
            var product = Products.FirstOrDefault(p => p.Id == id);
            if (product == null) return NotFound();

            Products.Remove(product);
            Console.WriteLine(product.Name + " was deleted");

            return NoContent();
        }
    }

    public class Product
    {
        public string Id { get; set; } = Guid.NewGuid().ToString();
        public string Name { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
        public double Price { get; set; }
    }
}
