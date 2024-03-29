﻿using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using Repositories.Dto;
using Repositories.Interfaces;

namespace OJT_Train.Core.Areas.Admin.Controllers
{
    [Area("Admin")]
    public class CategoryController : Controller
    {
        private readonly ICategoryRepository _repo;
        public CategoryController(ICategoryRepository repo)
        {
            _repo = repo;
        }
        private IActionResult CheckAdminAccess()
        {
            if (HttpContext.Session.GetString("RoleName") != "Admin")
            {
                return RedirectToAction("Unauthorized", "Error");
            }

            return null;
        }
        public IActionResult Index()
        {
            var accessResult = CheckAdminAccess();
            if (accessResult != null)
            {
                return accessResult;
            }
            return View();
        }

        public async Task<IActionResult> GetCategory()
        {
            var listCategory = await _repo.GetAll();
            return Json(listCategory);
        }
        [HttpPost]
        public IActionResult CreateCategory([FromBody] CategoryDTO model)
        {
            _repo.Add(model);
            return Json(new { success = true, data = model });
        }
        [HttpPost]
        public IActionResult UpdateCategory([FromBody] CategoryDTO model)
        {
            _repo.Update(model);
            return Json(new { success = true, data = model });
        }
        [HttpPost]
        public IActionResult DeleteCategory([FromBody] CategoryDTO model)
        {
            _repo.Delete(model);
            return Json(new { success = true, data = model });
        }
        [HttpPost]
        public IActionResult LoadExcel([FromBody] List<CategoryExcel> jsonData)
        {
            string jsonString = JsonConvert.SerializeObject(jsonData);
            _repo.AddCateExcel(jsonString);
            return Json(new { success = true, message = "Data processed successfully" });
        }
    }
}
