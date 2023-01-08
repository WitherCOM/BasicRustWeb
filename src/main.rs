use axum::{
    routing:get,
    Router
}

async fn index() -> &'static string {
    "Hello, World!"
}

#[tokio::main]
async fn main() {
    let app = Router::new().route('/',get(index));
        
    axum::Server::bind(&"0.0.0.0:80".parse().unwrap())
        .serve(app.into_make_service())
        .await
        .unwrap()
}
