import categoryModel from '../models/category.model.js';

export default function (app) {
    app.use(async function (req, res, next) {
        res.locals.lcCategories = await categoryModel.findAllWithDetails();
        next();
    });
}