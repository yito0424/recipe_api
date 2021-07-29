class RecipesController < ApplicationController
    def index
        @recipes = Recipe.all
        render json: @recipes, status: :ok
    end
    def create
        @recipe = Recipe.new(recipe_params)
        if @recipe.save
            res_json = { 
                message: 'Recipe successfully created!',
                recipe: @recipe }
            render json: res_json, status: :ok
        else
            attr_list = %i[title making_time serves ingredients cost]
            lack_attrs = ''
            attr_list.each do |attr|
                if !params[attr]
                    if lack_attrs.length != 0
                        lack_attrs << ', '
                    end    
                    lack_attrs << attr.to_s
                end
            end
                res_json = { 
                    message: 'Recipe creation failed!',
                    required: lack_attrs }
                render json: res_json, status: :ok
        end
    end
    def show
        if Recipe.exists?(params[:id])
            @recipe = Recipe.find(params[:id])
            res_json = {
                message: 'Recipe details by id',
                recipe: @recipe
            }
            render json: res_json, status: :ok
        else
            res_json = {
                message: "Recipe doesn't exist"
            }
            render json: res_json, status: :ok
        end
    end
    def update
        if Recipe.exists?(params[:id])
            @recipe = Recipe.find(params[:id])
            if @recipe.update(recipe_params)
                res_json = {
                    message: 'Recipe successfully updated!',
                    recipe: @recipe
                }
                render json: res_json, status: :ok
            else
                res_json = {
                    message: 'Failed to update recipe!'
                }
                render json: res_json, status: :ok
            end
        else
            res_json = {
                message: "Recipe doesn't exist"
            }
            render json: res_json, status: :ok
        end
    end
    def destroy
        if Recipe.exists?(params[:id])
            recipe = Recipe.find(params[:id])
            recipe.destroy
            res_json = {
                message: 'Recipe successfully removed!'
            }
            render json: res_json, status: :ok
        else
            res_json = {
                message: "Recipe doesn't exist"
            }
            render json: res_json, status: :ok
        end
    end
    private

    def recipe_params
        params.permit(:title, :making_time, :serves, :ingredients, :cost)
    end

end
