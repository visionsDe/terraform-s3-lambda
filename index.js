const { S3Client, GetObjectTaggingCommand, HeadObjectCommand } = require('@aws-sdk/client-s3');
const s3 = new S3Client();

exports.handler = async (event) => {
    console.log('Received S3 event:', JSON.stringify(event, null, 2));
    
    try {
        const s3Records = event.Records.map(record => JSON.parse(record.body).Records).flat();
        
        for (const record of s3Records) {
            const bucketName = record.s3.bucket.name;
            const objectKey = decodeURIComponent(record.s3.object.key.replace(/\+/g, ' '));
            
            // Get object tags
            const tagsResponse = await s3.send(new GetObjectTaggingCommand({ Bucket: bucketName, Key: objectKey }));
            console.log('Tags response:', JSON.stringify(tagsResponse, null, 2));
            
            // Get object metadata
            const metadataResponse = await s3.send(new HeadObjectCommand({ Bucket: bucketName, Key: objectKey }));
            console.log('Metadata response:', JSON.stringify(metadataResponse, null, 2));
        }
        
        return {
            statusCode: 200,
            body: JSON.stringify('Processed S3 event'),
        };
    } catch (err) {
        console.error('Error processing S3 event:', err);
        throw err;
    }
};
