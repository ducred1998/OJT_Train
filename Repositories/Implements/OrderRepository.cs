﻿using Dapper;
using Repositories.DataAccess;
using Repositories.Dto;
using Repositories.Interfaces;
using System.Data;

namespace Repositories.Implements
{
    public class OrderRepository : DapperBase, IOrderRepository
    {
        public async void DeleteOrder(int id)
        {
            await WithConnection(async connection =>
            {
                var parameter = new DynamicParameters();
                parameter.Add("orderId", id, DbType.Int32);
                await connection.ExecuteAsync("DeleteOrderByAdmin", param: parameter, commandType: CommandType.StoredProcedure);
            });
        }

        public async Task<IEnumerable<OrderDTO>> GetAll()
        {
            return await WithConnection(async connection =>
            {
                var orders = await connection.QueryAsync<OrderDTO>("GetOrderInfo", null, commandType: CommandType.StoredProcedure);
                return orders.ToList();
            });
        }

        public async Task<OrderById> GetById(int id)
        {
            return await WithConnection(async connection =>
            {
                var parameter = new DynamicParameters();
                parameter.Add("orderId", id, DbType.Int32);
                var order = await connection.QueryFirstOrDefaultAsync<OrderById>("GetOrderById", param: parameter, commandType: CommandType.StoredProcedure);
                return order;
            });
        }

        public async Task<IEnumerable<OrderDetail>> GetOrderDetail(int id)
        {
            return await WithConnection(async connection =>
            {
                var parameter = new DynamicParameters();
                parameter.Add("orderId", id, DbType.Int32);
                var orderDetails = await connection.QueryAsync<OrderDetail>("GetOrderDetail", param: parameter, commandType: CommandType.StoredProcedure);
                return orderDetails.ToList();
            });
        }

        public async void ShippingOrder(int id)
        {
            await WithConnection(async connection =>
            {
                var parameter = new DynamicParameters();
                parameter.Add("orderId", id, DbType.Int32);
                await connection.ExecuteAsync("ShippingOrder", param: parameter, commandType: CommandType.StoredProcedure);
            });
        }
    }
}
