const Category = require("../models/category");

function createCategories(categories, parentId = null) {
  const categoryList = [];
  let category;
  if (parentId == null) {
    category = categories.filter((cat) => cat.parentId == undefined);
  } else {
    category = categories.filter((cat) => cat.parentId == parentId);
  }

  for (let cate of category) {
    categoryList.push({
      _id: cate._id,
      categoryName: cate.categoryName,
      slug: cate.slug,
      Items: cate.Items,
      children: createCategories(categories, cate._id),
    });
  }
  return categoryList;
}

//@desc     Get all Categories
//@route    Get /api/v1/Categories
//@access   Public
exports.getCategories = (req, res, next) => {
  try {
    Category.find({}).exec((error, categories) => {
      if (categories) {
        const categoryList = createCategories(categories);
        res.status(200).json({ categoryList });
      }
    });
  } catch (err) {
    next(err);
  }
};
//@desc     Get a Category
//@route    Get /api/v1/Categories/:id
//@access   Public
exports.getCategory = (req, res, next) => {
  res.status(200).json({ success: true, msg: `Show Shop ${req.params.id}` });
};
//@desc     Create a Category
//@route    Post /api/v1/Categories
//@access   Public
exports.createCategory = async (req, res, next) => {
  try {
    const categoryObj = {
      categoryName: req.body.categoryName,
      categoryType: req.body.categoryType,
    };
    if (req.body.parentId) {
      categoryObj.parentId = req.body.parentId;
    }
    const cat = await Category.create(categoryObj);

    res.status(200).json({ success: true, data: cat });
  } catch (err) {
    next(err);
  }
};

//@desc     Update a Category
//@route    Put /api/v1/Categories/:id
//@access   Public
exports.updateCategory = (req, res, next) => {
  res.status(200).json({ success: true, msg: `Update Shop ${req.params.id}` });
};
//@desc     Delete a Category
//@route    Delete /api/v1/Categories/:id
//@access   Private
exports.deleteCategory = (req, res, next) => {
  res.status(200).json({ success: true, msg: `Delete Shop ${req.params.id}` });
};
