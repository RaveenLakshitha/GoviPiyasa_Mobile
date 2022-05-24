const Cart = require("../models/cart");

//@desc     Add Item to Cart
//@route    Post /api/v1/Categories
//@access   Public
exports.addItemToCart = async (req, res, next) => {
  try {
    const cart = new Cart({
      user: req.user.id,
      cartItems: req.body.cartItems,
      cartTotalPrice: req.body.cartTotalPrice,
    });

    //Check for createdCart
    const createdCart = await Cart.findOne({ user: req.user.id });

    if (createdCart) {
      //Check for addedItem in createdCart
      const product = req.body.cartItems.product;
      const item = await createdCart.cartItems.find(
        (i) => i.product == product
      );

      if (item) {
        await Cart.findOneAndUpdate(
          { user: req.user._id, "cartItems.product": product },
          {
            $set: {
              cartItems: {
                ...req.body.cartItems,
                quantity: item.quantity + req.body.cartItems.quantity,
              },
            },
          }
        );

        await Cart.findOneAndUpdate(
          { user: req.user._id, "cartItems.product": product },
          {
            $set: {
              cartItems: {
                ...req.body.cartItems,
                cartTotalPrice:
                  createdCart.cartTotalPrice + req.body.cartTotalPrice,
              },
            },
          }
        );
      } else {
        await Cart.findOneAndUpdate(
          { user: req.user._id },
          {
            $push: {
              cartItems: req.body.cartItems,
            },
          }
        );
      }

      return res.status(200).json({ success: true, data: cart });
    }

    cart.save((error, cart) => {
      if (cart) {
        return res.status(200).json({ success: true, data: cart });
      } else console.log(error);
    });
  } catch (err) {
    next(err);
  }
};
//@desc     Remove item from Cart
//@route    Post /api/v1/Categories
//@access   Public
exports.removeItemFromCart = async (req, res, next) => {
  try {
    const cart = new Cart({
      user: req.user.id,
      cartItems: req.body.cartItems,
    });

    cart.save((cart) => {
      if (cart) {
        return res.status(200).json({ success: true, data: cart });
      }
    });
  } catch (err) {
    next(err);
  }
};
