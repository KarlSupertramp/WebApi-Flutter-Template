using Microsoft.AspNetCore.Mvc;

namespace RestServer.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ProductsController : ControllerBase
    {
        // Brought to you by ChatGPT ;)
        private static List<Product> Products = new()
        {
            new Product { Name = "Fishing Rod", Price = 12999, Description = "Durable carbon fiber fishing rod suitable for both freshwater and saltwater fishing." },
            new Product { Name = "Spinning Reel", Price = 8999, Description = "High-performance spinning reel with smooth drag and anti-reverse technology." },
            new Product { Name = "Fishing Line", Price = 1999, Description = "Strong and abrasion-resistant fishing line for reliable catches." },
            new Product { Name = "Tackle Box", Price = 3499, Description = "Spacious tackle box with multiple compartments for organizing fishing gear." },
            new Product { Name = "Fishing Hooks Set", Price = 1499, Description = "Variety pack of high-quality fishing hooks for different fish species." },
            new Product { Name = "Lure Kit", Price = 3999, Description = "Assorted lure kit with crankbaits, soft plastics, and jigs for versatile fishing." },
            new Product { Name = "Fishing Net", Price = 2499, Description = "Lightweight and foldable fishing net for easy catch and release." },
            new Product { Name = "Fish Finder", Price = 19999, Description = "Advanced fish finder with sonar technology for locating fish underwater." },
            new Product { Name = "Bait Bucket", Price = 2299, Description = "Insulated bait bucket to keep live bait fresh for longer periods." },
            new Product { Name = "Fishing Vest", Price = 4999, Description = "Multi-pocket fishing vest for convenient storage of tools and accessories." },
            new Product { Name = "Fishing Waders", Price = 8999, Description = "Waterproof fishing waders for comfortable fishing in deep waters." },
            new Product { Name = "Rod Holder", Price = 1999, Description = "Adjustable rod holder for hands-free fishing on boats or shorelines." },
            new Product { Name = "Fishing Gloves", Price = 1499, Description = "Non-slip fishing gloves with UV protection and reinforced grip." },
            new Product { Name = "Baitcasting Reel", Price = 12999, Description = "Precision-engineered baitcasting reel for accurate casting and control." },
            new Product { Name = "Fishing Pliers", Price = 1699, Description = "Corrosion-resistant fishing pliers for cutting lines and removing hooks." },
            new Product { Name = "Tackle Backpack", Price = 5999, Description = "Heavy-duty tackle backpack with multiple storage compartments." },
            new Product { Name = "Fishing Chair", Price = 4499, Description = "Lightweight and foldable fishing chair for comfortable angling." },
            new Product { Name = "Fish Scale & Ruler", Price = 2499, Description = "Digital fish scale with a built-in ruler for measuring your catch." },
            new Product { Name = "Fishing Headlamp", Price = 2999, Description = "Bright LED fishing headlamp for nighttime fishing adventures." },
            new Product { Name = "Live Bait Aerator", Price = 3499, Description = "Battery-powered aerator to keep live bait oxygenated." }
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
            Console.Write($"Product added: {product.Name} ({product.Id})");
            return CreatedAtAction(nameof(GetProduct), new { id = product.Id }, product);
        }

        [HttpPut("{id}")]
        public IActionResult UpdateProduct(string id, [FromBody] Product updatedProduct)
        {
            var product = Products.FirstOrDefault(p => p.Id == id);
            if (product == null) return NotFound();

            product.Name = updatedProduct.Name;
            product.Description = updatedProduct.Description;
            product.Price = updatedProduct.Price;
            Console.Write($"Product updated: {product.Name} ({product.Id})");

            return NoContent();
        }

        [HttpDelete("{id}")]
        public IActionResult DeleteProduct(string id)
        {
            var product = Products.FirstOrDefault(p => p.Id == id);
            if (product == null) return NotFound();
            Products.Remove(product);

            Console.Write($"Product deleted: {product.Name} ({product.Id})");
            return NoContent();
        }
    }

    public class Product
    {
        public string Id { get; set; } = Guid.NewGuid().ToString();
        public string Name { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
        public int Price { get; set; }
    }
}
